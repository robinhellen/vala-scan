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
            stdout.printf(@"Option $((int32)option.ordinal): $(option.name): $(option.title): $(option.description)\n");

            var boolOpt = option as BoolOption;
            if(boolOpt != null)
            {
                stdout.printf(@"Boolean option. Currently $(boolOpt.get_value()).\n");
            }
            var intOpt = option as IntOption;
            if(intOpt != null)
            {
                stdout.printf(@"Integer option.");
                if(intOpt.get_legal_values() != null)
                {
                    stdout.printf(" Legal values are: [");
                    foreach(var l in intOpt.get_legal_values())
                    {
                        stdout.printf(@"$l, ");
                    }
                    stdout.printf(@"].");
                }
                stdout.printf(@" Has $(intOpt.size) values: [");
                try
                {
                    var values = intOpt.get_value();
                    foreach(var i in values)
                    {
                        stdout.printf(@"$i, ");
                    }
                }
                catch(ScannerError e)
                {
                    stdout.printf(@"$(e.message)");
                }
                stdout.printf("].\n");
            }
            var stringOpt = option as StringOption;
            if(stringOpt != null)
            {
                stdout.printf(@"String option. Legal values are: [");
                foreach(var st in stringOpt.get_legal_values())
                {
                    stdout.printf(@"$st, ");
                }
                stdout.printf(@"]. Current value is $(stringOpt.get_value()).\n");
            }
        }

        return 0;
    }
}
