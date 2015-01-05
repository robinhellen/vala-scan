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

    public abstract class Option : Object
    {
        internal static Option create(OptionDescriptor option, ScannerSession session, int ordinal)
        {
            switch(option.type)
            {
                case ValueType.BOOL:
                    return new BoolOption(option, session, ordinal);
                case ValueType.INT:
                    return new IntOption(option, session, ordinal);
                case ValueType.FIXED:
                    return new FixedOption(option, session, ordinal);
                case ValueType.STRING:
                    return new StringOption(option, session, ordinal);
                case ValueType.BUTTON:
                    return new ButtonOption(option, session, ordinal);
                case ValueType.GROUP:
                    return new GroupOption(option, session, ordinal);
                default:
                    assert_not_reached();
            }
        }

        public string name {get; construct;}
        public string title {get; construct;}
        public string description {get; construct;}

        internal OptionDescriptor option;
        internal ScannerSession session;
        internal Int ordinal;

        internal Option(OptionDescriptor d, ScannerSession s, Int n)
        {
            Object(name: d.name, title: d.title, description: d.desc);
            option = d;
            session = s;
            ordinal = n;
        }

        internal bool CheckActionStatus(Int status)
        {
            if((status & Info.RELOAD_OPTIONS) == Info.RELOAD_OPTIONS)
                session.options_changed();
            if((status & Info.RELOAD_PARAMS) == Info.RELOAD_PARAMS)
                session.parameters_changed();
            return (status & Info.INEXACT) == Info.INEXACT;
        }
    }

    public class BoolOption : Option
    {
        internal BoolOption(OptionDescriptor o, ScannerSession s, Int n)
        {
            base(o, s, n);
        }

        public bool get_value()
            throws ScannerError
        {
            Bool val = Bool.FALSE;
            ThrowIfFailed(session.handle.control_option(ordinal, Action.GET_VALUE, &val, null));
            return ConvertFromSaneBool(val);
        }

        public void set_value(bool val)
            throws ScannerError
        {
            Int _;
            ThrowIfFailed(session.handle.control_option(ordinal, Action.SET_VALUE, &val, out _));
            CheckActionStatus(_);
        }
    }

    public class IntOption : Option
    {
        public int size;

        internal IntOption(OptionDescriptor o, ScannerSession s, Int n)
        {
            base(o, s, n);
            size = o.size;
        }

        public int[] get_value()
            throws ScannerError
        {
            Int[] val = new Int[option.size];
            ThrowIfFailed(session.handle.control_option(ordinal, Action.GET_VALUE, val, null));
            var result = new int[option.size];
            for(int i = 0; i < option.size; i++)
            {
                result[i] = val[i];
            }
            return result;
        }

        public int[] set_value(int[] val)
            throws ScannerError
            requires(val.length == option.size)
        {
            Int _;
            ThrowIfFailed(session.handle.control_option(ordinal, Action.SET_VALUE, &val, out _));
            if(CheckActionStatus(_))
                return get_value();
            return val;
        }
    }

    public class FixedOption : Option
    {
        internal FixedOption(OptionDescriptor o, ScannerSession s, Int n)
        {
            base(o, s, n);
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
