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

        var s = scanners.to_array()[0];
        var session = context.open_scanner(s);
        var options = session.get_options();
        foreach(var option in options)
        {
            stdout.printf(@"Option: $(option.name): $(option.title): $(option.description)\n");

            var boolOpt = option as BoolOption;
            if(boolOpt != null)
            {
                stdout.printf(@"Boolean option. Currently $(boolOpt.get_value()).\n");
            }
            var intOpt = option as IntOption;
            if(intOpt != null)
            {
                stdout.printf(@"Integer option. Has $(intOpt.size) values: [");
                foreach(var i in intOpt.get_value())
                {
                    stdout.printf(@"$i, ");
                }
                stdout.printf("].\n");
            }
        }

        return 0;
    }
}
