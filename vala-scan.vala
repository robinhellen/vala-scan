using Sane;

namespace Scan
{
    public class ScanContext : Object
    {
        private Int sane_version;

        construct
        {
            init(out sane_version, null);
        }

        ~ScanContext()
        {
            exit();
        }
    }
}
