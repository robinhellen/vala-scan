using Sane;

namespace Scan
{
    public class FixedOption : Option
    {
        internal FixedOption(OptionDescriptor o, ScannerSession s, Int n)
        {
            base(o, s, n);
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
            requires(val.length == option.size)
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
            Fixed[] val = new Fixed[option.size];
            ThrowIfFailed(session.handle.control_option(ordinal, Action.GET_VALUE, val, null));
            var result = new double[option.size];
            for(int i = 0; i < option.size; i++)
            {
                result[i] = val[i].to_double();
            }
            return result;
        }

        public double[] set_value_from_double(double[] val)
            throws ScannerError
            requires(val.length == option.size)
            requires(can_set_value)
        {
            Int _;
            Fixed[] fixed_val = new Fixed[option.size];
            for(int i = 0; i < option.size; i++)
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
