using Gee;
using Sane;

namespace Scan
{
    public class ScannerSession : Object
    {
        internal Handle handle;
        public Parameters current_parameters;
        private Map<string, Option> current_options;

        internal ScannerSession(Handle h)
        {
            handle = h;
            handle.get_parameters(out current_parameters);
        }

        public Collection<Option> get_options()
        {
            load_options();

            return current_options.values;
        }

        public T? get_option_by_name<T>(string option_name)
            requires(typeof(T).is_a(typeof(Option)))
        {
            load_options();
            var opt = current_options[option_name];

            if(opt == null || opt.get_type() != typeof(T))
                return null;

            return (T)opt;
        }

        private void load_options()
        {
            if(current_options != null)
                return;

            current_options = new HashMap<string, Option>(x => str_hash(x), (x,y) => strcmp(x,y) == 0);

            Int option_count = 0;
            handle.control_option(0, Sane.Action.GET_VALUE, &option_count, null);

            for(int o = 0; o < option_count; o++)
            {
                var option = Option.create(handle.get_option_descriptor(o), this, o);
                current_options[option.name] = option;
            }
        }

        public virtual signal void options_changed()
        {
            current_options = null;
        }

        public virtual signal void parameters_changed()
        {
            handle.get_parameters(out current_parameters);
        }

        public ScannedFrame capture(int buffer_size = 1024)
            throws ScannerError
        {
            ThrowIfFailed(handle.start());
            Parameters p;
            ThrowIfFailed(handle.get_parameters(out p));
            var result = new ScannedFrame(p);

            var buffer = new Byte[buffer_size];
            int bytes_read = 0;
            while(true)
            {
                Int len;
                var status = handle.read(buffer, out len);
                ThrowIfFailed(handle.get_parameters(out p));
                if(status == Status.EOF)
                {
                    break;
                }
                ThrowIfFailed(status);

                // This is a reference into the original not a copy (see Vala manual)
                unowned uint8[] dest_slice = result.data[bytes_read: bytes_read + len];

                // copy into data
                for(int i = 0; i < len; i++)
                {
                    dest_slice[i] = buffer[i];
                }
                bytes_read += len;
            }
            return result;
        }

        public async ScannedFrame capture_async(int buffer_size = 1024, Cancellable cancel = null)
            throws ScannerError
        {
            ThrowIfFailed(handle.set_io_mode(Bool.TRUE));
            Parameters p;
            ThrowIfFailed(handle.get_parameters(out p));
            var result = new ScannedFrame(p);

            Int fd;
            ThrowIfFailed(handle.get_select_fd(out fd));
            int unixFd = fd;
            var channel = new IOChannel.unix_new(unixFd);
            var source = new IOSource(channel, IOCondition.IN);
            int bytes_read = 0;
            source.set_callback((_, __) => {
                var buffer = new Byte[buffer_size];
                while(true)
                {
                    if(cancel != null && cancel.is_cancelled())
                    {
                        handle.cancel();
                        throw new ScannerError.Cancelled("The capture operation was cancelled.");
                    }
                    Int len;
                    var status = handle.read(buffer, out len);

                    if(status == Status.EOF)
                    {
                        Idle.add(capture_async.callback);
                        return false;
                    }
                    if(len == 0)
                    {
                        return true;
                    }
                    ThrowIfFailed(status);

                    // This is a reference into the original not a copy (see Vala manual)
                    unowned uint8[] dest_slice = result.data[bytes_read: bytes_read + len];

                    // copy into data
                    for(int i = 0; i < len; i++)
                    {
                        dest_slice[i] = buffer[i];
                    }
                    bytes_read += len;
                }
                return false;
            });
            source.attach(null);
            yield;

            return result;
        }

        ~ScannerSession()
        {
            handle.close();
        }
    }

    public class ScannedFrame : Object
    {
        internal ScannedFrame(Parameters p)
        {
            BytesPerLine = p.bytes_per_line;
            PixelsPerLine = p.pixels_per_line;
            Lines = p.lines;
            Depth = p.depth;

            var total_bytes = BytesPerLine * Lines;
            data = new uint8[total_bytes];
        }

        public int BytesPerLine;
        public int PixelsPerLine;
        public int Lines;
        public int Depth;

        public uint8[] data;
    }
}
