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

        public signal void options_changed();

        public signal void parameters_changed();

        ~ScannerSession()
        {
            handle.close();
        }
    }

    public class StringOption : Option
    {
        internal StringOption(OptionDescriptor o, ScannerSession s, Int n)
        {
            base(o, s, n);
        }
    }

    public class ButtonOption : Option
    {
        internal ButtonOption(OptionDescriptor o, ScannerSession s, Int n)
        {
            base(o, s, n);
        }
    }

    public class GroupOption : Option
    {
        internal GroupOption(OptionDescriptor o, ScannerSession s, Int n)
        {
            base(o, s, n);
        }
    }
}
