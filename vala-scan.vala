using Gee;
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
            }
            return result;
        }

        ~ScanContext()
        {
            exit();
        }
    }

    private Bool ConvertToSaneBool(bool b)
    {
        if(b)
            return Bool.TRUE;
        return Bool.FALSE;
    }

    public class Scanner : Object
    {
        public string model {get; construct;}
        public string vendor {get; construct;}
        public string name {get; construct;}
        public string device_type {get; construct;}

        internal Scanner(Device d)
        {
            Object(model: d.model, vendor: d.vendor, name: d.name, device_type: d.type);
        }
    }
}
