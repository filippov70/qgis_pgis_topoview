#!/bin/sh

#
# Sandro Santilli <strk@keybit.net>
# Work in the public domain
#
# Version 0.1-dev
#
#
#

usage()
{
	echo "Usage: [PGDATABASE=<dbname>] $0 [-x] <toponame>" 
	echo " -x   open the generated project file with qgis"
}

do_open=no

if test x"$1" = "x-h"; then
	usage 
	exit 
fi

if test x"$1" = "x-x"; then
	do_open=yes
	shift
fi

if test x"$1" = x; then
	usage >&2 
	exit 1
fi

TPL="$(dirname $0)/topoview_tpl.qgs"
TOPONAME="$1"

if test x"${PGDATABASE}" = x; then
	PGDATABASE=$(whoami)
fi

PRJFILE="topo_view_${PGDATABASE}_${TOPONAME}.qgs"

do_write=yes
if test -e "${PRJFILE}"; then
	echo -n "Project '${PRJFILE}' already exists, override [y/N] ? "
	read OVERRIDE
	if test x${OVERRIDE} != 'xy'; then
		do_write=no
	fi
fi

if test x"$do_write" = xyes; then
	sed -e "s/@@DBNAME@@/${PGDATABASE}/g" \
	    -e "s/@@TOPONAME@@/${TOPONAME}/g" \
	    "${TPL}" > "${PRJFILE}"
fi
    
if test x"$do_open" = "xyes"; then
	qgis "${PRJFILE}"
fi

echo "Project file: ${PRJFILE}"
