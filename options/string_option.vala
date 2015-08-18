using Sane;

namespace Scan
{
    public class StringOption : Option
    {
        int size;

        internal StringOption(OptionDescriptor o, ScannerSession s, Int n)
        {
            base(o, s, n);
            size = (int)(o.size / sizeof(char));
        }

        public string[]? get_legal_values()
        {
            if(option.constraint_type == ConstraintType.NONE)
                return null;

            if(option.constraint_type != ConstraintType.STRING_LIST)
                assert_not_reached();

            var values = new string[]{};

            foreach(unowned StringConst s in option.string_list)
            {
                values += s.dup();
            }

            return values;
        }

        public string get_value()
            throws ScannerError
            requires(can_read_value)
        {
            var val = string.nfill(size, 0);
            ThrowIfFailed(session.handle.control_option(ordinal, Action.GET_VALUE, val, null));
            return val;
        }

        public string set_value(string val)
            throws ScannerError
            requires(val.length <= size)
            requires(can_set_value)
        {
            Int _;
            ThrowIfFailed(session.handle.control_option(ordinal, Action.SET_VALUE, val, out _));
            if(CheckActionStatus(_))
                return get_value();
            return val;
        }
    }
}
