
OPTIONS_SOURCES = options/option.vala options/int_option.vala options/bool_option.vala options/fixed_option.vala options/string_option.vala options/button_option.vala options/group_option.vala
LIBRARY_SOURCES = vala-scan.vala scanner_error.vala scanner_session.vala $(OPTIONS_SOURCES)

all: vala-scan.so

vala-scan.so: sane-backend-vapi/sane-backends.vapi $(LIBRARY_SOURCES)
	valac-0.26 --vapidir=sane-backend-vapi --pkg=sane-backends --pkg=gee-0.8 --pkg=gio-2.0 --library=vala-scan -H vala-scan.h $(LIBRARY_SOURCES) -X -fpic -X -shared -X -w -g -o vala-scan.so

