using Scan;

namespace Scan.TestApp
{
    public static int main(string[] args)
    {
        var context = new ScanContext();
        var scanners = context.get_devices(true);

        if(scanners.is_empty)
        {
            stderr.printf("No scanners found.\n");
            return -1;
        }

        foreach(var s in scanners)
        {
            stdout.printf(@"Found scanner: $(s.name) [$(s.vendor) $(s.model)($(s.device_type))]\n");
        }

        return 0;
    }
}
