using Sane;

namespace Scan
{
    public class BoolOption : Option
    {
        internal BoolOption(OptionDescriptor o, ScannerSession s, Int n)
        {
            base(o, s, n);
        }

        public bool get_value()
            throws ScannerError
            requires(can_read_value)
        {
            Bool val = Bool.FALSE;
            ThrowIfFailed(session.handle.control_option(ordinal, Sane.Action.GET_VALUE, &val, null));
            return ConvertFromSaneBool(val);
        }

        public void set_value(bool val)
            throws ScannerError
            requires(can_set_value)
        {
            Int _;
            ThrowIfFailed(session.handle.control_option(ordinal, Sane.Action.SET_VALUE, &val, out _));
            CheckActionStatus(_);
        }
    }
}
