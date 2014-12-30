using Gee;
using Sane;

namespace Scan
{
    public class ScannerSession : Object
    {
        private Handle handle;

        internal ScannerSession(Handle h)
        {
            handle = h;
        }

        public Collection<Option> get_options()
        {
            Int option_count = 0;
            Int unused; // only get useful information if we pass SET to control_option
            handle.control_option(0, Action.GET_VALUE, &option_count, out unused);

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

    public abstract class Option : Object
    {
        internal static Option create(OptionDescriptor option, ScannerSession session, int ordinal)
        {
            switch(option.type)
            {
                case ValueType.BOOL:
                    return new BoolOption(option, session);
                case ValueType.INT:
                    return new IntOption(option, session);
                case ValueType.FIXED:
                    return new FixedOption(option, session);
                case ValueType.STRING:
                    return new StringOption(option, session);
                case ValueType.BUTTON:
                    return new ButtonOption(option, session);
                case ValueType.GROUP:
                    return new GroupOption(option, session);
                default:
                    assert_not_reached();
            }
        }

        public string name {get; construct;}
        public string title {get; construct;}
        public string description {get; construct;}

        internal OptionDescriptor option;
        internal ScannerSession session;

        internal Option(OptionDescriptor d, ScannerSession s)
        {
            Object(name: d.name, title: d.title, description: d.desc);
            option = d;
            session = s;
        }
    }

    public class BoolOption : Option
    {
        public BoolOption(OptionDescriptor o, ScannerSession s)
        {
            base(o, s);
        }
    }

    public class IntOption : Option
    {
        public IntOption(OptionDescriptor o, ScannerSession s)
        {
            base(o, s);
        }
    }

    public class FixedOption : Option
    {
        public FixedOption(OptionDescriptor o, ScannerSession s)
        {
            base(o, s);
        }
    }

    public class StringOption : Option
    {
        public StringOption(OptionDescriptor o, ScannerSession s)
        {
            base(o, s);
        }
    }

    public class ButtonOption : Option
    {
        public ButtonOption(OptionDescriptor o, ScannerSession s)
        {
            base(o, s);
        }
    }

    public class GroupOption : Option
    {
        public GroupOption(OptionDescriptor o, ScannerSession s)
        {
            base(o, s);
        }
    }
}
