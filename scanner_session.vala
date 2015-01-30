using Gee;
using Sane;

namespace Scan
{
    public class ScannerSession : Object
    {
        internal Handle handle;

        internal ScannerSession(Handle h)
        {
            handle = h;
        }

        public Collection<Option> get_options()
        {
            Int option_count = 0;
            handle.control_option(0, Action.GET_VALUE, &option_count, null);

            var result = new ArrayList<Option>();
            for(int o = 1; o < option_count; o++)
            {
                result.add(Option.create(handle.get_option_descriptor(o), this, o));
            }
            return result;
        }

        public T? get_option_by_name<T>(string option_name)
            requires(typeof(T).is_a(typeof(Option)))
        {
            Int option_count = 0;
            handle.control_option(0, Action.GET_VALUE, &option_count, null);

            for(int o = 1; o < option_count; o++)
            {
                var descriptor = handle.get_option_descriptor(o);
                if(descriptor.name == option_name)
                {
                    var opt = Option.create(descriptor, this, o);
                    if(opt.get_type() != typeof(T))
                        return null;

                    return (T)opt;
                }
            }
            return null;
        }

        public signal void options_changed();

        public signal void parameters_changed();

        public ScannedFrame capture()
            throws ScannerError
        {
            ThrowIfFailed(handle.start());
            Parameters p;
            ThrowIfFailed(handle.get_parameters(out p));
            var result = new ScannedFrame(p);

            var buffer = new Byte[128];
            int bytes_read = 0;
            while(true)
            {
                Int len;
                var status = handle.read(buffer, out len);
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
