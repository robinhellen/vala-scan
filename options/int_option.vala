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

        public int[] get_value()
            throws ScannerError
            requires(can_read_value)
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
            requires(val.length == size)
            requires(can_set_value)
        {
            Int _;
            ThrowIfFailed(session.handle.control_option(ordinal, Action.SET_VALUE, &val, out _));
            if(CheckActionStatus(_))
                return get_value();
            return val;
        }
    }
}
