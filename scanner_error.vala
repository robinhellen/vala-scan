using Sane;

namespace Scan
{
    public errordomain ScannerError
    {
        Unsupported,
        Cancelled,
        DeviceBusy,
        InvalidArgument,
        EndOfFile,
        Jammed,
        NoMoreDocuments,
        CoverOpen,
        IoError,
        NoMemory,
        AccessDenied
    }
    private void ThrowIfFailed(Status s)
        throws ScannerError
    {
        unowned StringConst message = s.to_string();
        switch(s)
        {
            case Status.GOOD:
                return;
            case Status.UNSUPPORTED:
                throw new ScannerError.Unsupported(message);
            case Status.DEVICE_BUSY:
                throw new ScannerError.DeviceBusy(message);
            case Status.INVAL:
                throw new ScannerError.InvalidArgument(message);
            case Status.EOF:
                throw new ScannerError.EndOfFile(message);
            case Status.JAMMED:
                throw new ScannerError.Jammed(message);
            case Status.NO_DOCS:
                throw new ScannerError.NoMoreDocuments(message);
            case Status.COVER_OPEN:
                throw new ScannerError.CoverOpen(message);
            case Status.IO_ERROR:
                throw new ScannerError.IoError(message);
            case Status.NO_MEM:
                throw new ScannerError.NoMemory(message);
            case Status.ACCESS_DENIED:
                throw new ScannerError.AccessDenied(message);
            default:
                error("Unrecognised status return: %d", s);
        }
    }
}
