using Sane;

namespace Scan
{
    public class IntOption : Option
    {
        public int size;

        internal IntOption(OptionDescriptor o, ScannerSession s, Int n)
        {
            base(o, s, n);
            size = (int)(o.size / sizeof(Int));
        }

        public int32[] get_value()
            throws ScannerError
            requires(can_read_value)
        {
            Int[] val = new Int[size];
            ThrowIfFailed(session.handle.control_option(ordinal, Action.GET_VALUE, val, null));
            var result = new int[size];
            for(int i = 0; i < size; i++)
            {
                result[i] = val[i];
            }
            return result;
        }

        public int32[] set_value(int32[] val)
            throws ScannerError
            requires(val.length == size)
            requires(can_set_value)
        {
            Int _;
            Int[] sane_values = new Int[size];
            for(int i = 0; i < size; i++)
            {
                sane_values[i] = val[i];
            }

            ThrowIfFailed(session.handle.control_option(ordinal, Action.SET_VALUE, sane_values, out _));
            if(CheckActionStatus(_))
            {
                return get_value();
            }
            return val;
        }

        public int32[]? get_legal_values()
        {
            if(option.constraint_type != ConstraintType.WORD_LIST)
                return null;

            var values = new int[]{};
            var len = (int32)option.word_list[0];
            for(int i = 1; i < len + 1; i++)
            {
                values += (int)option.word_list[i];
            }

            return values;
        }
    }
}
