using Sane;

namespace Scan
{
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
}
