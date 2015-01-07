using Sane;

namespace Scan
{
    public class FixedOption : Option
    {
        public int size;

        internal FixedOption(OptionDescriptor o, ScannerSession s, Int n)
        {
            base(o, s, n);
            size = (int)(o.size / sizeof(Int));
        }

        public int[] get_value()
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

        public double[] get_value_as_double()
            throws ScannerError
            requires(can_read_value)
        {
            Fixed[] val = new Fixed[size];
            ThrowIfFailed(session.handle.control_option(ordinal, Action.GET_VALUE, val, null));
            var result = new double[size];
            for(int i = 0; i < size; i++)
            {
                result[i] = val[i].to_double();
            }
            return result;
        }

        public double[] set_value_from_double(double[] val)
            throws ScannerError
            requires(val.length == size)
            requires(can_set_value)
        {
            Int _;
            Fixed[] fixed_val = new Fixed[size];
            for(int i = 0; i < size; i++)
            {
                fixed_val[i] = Fixed.from_double(val[i]);
            }

            ThrowIfFailed(session.handle.control_option(ordinal, Action.SET_VALUE, &val, out _));
            if(CheckActionStatus(_))
                return get_value_as_double();
            return val;
        }
    }
}
