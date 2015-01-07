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

        ~ScannerSession()
        {
            handle.close();
        }
    }
}
