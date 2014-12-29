using Sane;

namespace Scan
{
    public class ScannerSession : Object
    {
        private Handle handle;

        internal ScannerSession(Handle h)
        {
            handle = h;
        }

        ~ScannerSession()
        {
            handle.close();
        }
    }
}
