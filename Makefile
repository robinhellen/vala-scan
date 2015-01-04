
LIBRARY_SOURCES = vala-scan.vala scanner_error.vala scanner_session.vala

all: vala-scan.so

vala-scan.so: sane-backend-vapi/sane-backends.vapi $(LIBRARY_SOURCES)
	valac-0.24 --vapidir=sane-backend-vapi --pkg=sane-backends --pkg=gee-0.8 --library=vala-scan -H vala-scan.h $(LIBRARY_SOURCES) -X -fpic -X -shared -o vala-scan.so

