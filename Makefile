all:
	valac-0.24 --vapidir=sane-backend-vapi --pkg=sane-backends --library=vala-scan -H vala-scan.h vala-scan.vala -X -fpic -X -shared -o vala-scan.so

