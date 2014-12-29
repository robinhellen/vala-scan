using Sane;

namespace Scan
{
    public class ScanContext : Object
    {
        private Int sane_version;

        construct
        {
            var status = init(out sane_version, null);
            if(status != Status.GOOD)
            {
                error("Unable to initialize SANE library: %s", status.to_string());
                assert_not_reached();
            }
        }

        ~ScanContext()
        {
            exit();
        }
    }
}
