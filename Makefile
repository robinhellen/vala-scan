all:
	valac-0.24 --vapidir=sane-backend-vapi --pkg=sane-backends --pkg=gee-0.8 --library=vala-scan -H vala-scan.h vala-scan.vala scanner_error.vala scanner_session.vala -X -fpic -X -shared -o vala-scan.so

