using Gee;
using Sane;

namespace Scan
{
    public class ScanContext : Object
    {
        private Int sane_version;
        private static ScanContext current_context = null;

        construct
        {
            if(current_context != null)
            {
                error("Only one scan context may be active at a time.");
                assert_not_reached();
            }
            var status = init(out sane_version, null);
            if(status != Status.GOOD)
            {
                error("Unable to initialize SANE library: %s", status.to_string());
                assert_not_reached();
            }
            current_context = this;
        }

        public Collection<Scanner> get_devices(bool local_only)
            throws ScannerError
        {
            unowned Device?[] devices;
            var status = Sane.get_devices(out devices, ConvertToSaneBool(local_only));
            ThrowIfFailed(status);
            int i = 0;
            var result = new ArrayList<Scanner>();
            while(devices[i] != null)
            {
                result.add(new Scanner(devices[i]));
                i++;
            }
            return result;
        }

        public ScannerSession open_scanner(Scanner s)
            throws ScannerError
        {
            Handle h;
            ThrowIfFailed(Handle.open(s.original.name, out h));
            return new ScannerSession(h);
        }

        ~ScanContext()
        {
            exit();
            current_context = null;
        }
    }

    private Bool ConvertToSaneBool(bool b)
    {
        if(b)
            return Bool.TRUE;
        return Bool.FALSE;
    }

    private bool ConvertFromSaneBool(Bool b)
    {
        switch(b)
        {
            case Bool.TRUE:
                return true;
            case Bool.FALSE:
                return false;
            default:
                assert_not_reached();
        }
    }

    public class Scanner : Object
    {
        public string model {get; construct;}
        public string vendor {get; construct;}
        public string name {get; construct;}
        public string device_type {get; construct;}

        internal Device original;

        internal Scanner(Device d)
        {
            Object(model: d.model, vendor: d.vendor, name: d.name, device_type: d.type);
            original = d;
        }
    }

    public interface ProgressReporter : Object
    {
        public abstract void report(double progress);
    }
}
