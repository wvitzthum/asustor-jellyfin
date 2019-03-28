#!/bin/sh

APKG_PKG_DIR=/usr/local/AppCentral/Jellyfin

case "$APKG_PKG_STATUS" in

	install)
		;;
	upgrade)
		# pre upgrade script here (backup data)
		# cp $APKG_PKG_DIR/etc/Jellyfin.conf $APKG_TEMP_DIR/Jellyfin.conf
		;;
	*)
		;;

esac

exit 0
