
OPTIONS_SOURCES = options/option.vala options/int_option.vala options/bool_option.vala options/fixed_option.vala
LIBRARY_SOURCES = vala-scan.vala scanner_error.vala scanner_session.vala $(OPTIONS_SOURCES)

all: vala-scan.so

vala-scan.so: sane-backend-vapi/sane-backends.vapi $(LIBRARY_SOURCES)
	valac-0.24 --vapidir=sane-backend-vapi --pkg=sane-backends --pkg=gee-0.8 --library=vala-scan -H vala-scan.h $(LIBRARY_SOURCES) -X -fpic -X -shared -g -o vala-scan.so

