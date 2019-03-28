#!/bin/sh

APKG_PKG_DIR=/usr/local/AppCentral/Jellyfin

case "$APKG_PKG_STATUS" in

	install)
		# pre install script here
		# installing bash over entware
		/usr/local/AppCentral/entware/opt/bin/opkg install bash
		ln -sf /usr/local/AppCentral/entware/opt/bin/bash /bin/bash
		;;
	upgrade)
		# mv $APKG_TEMP_DIR/RoonServer.conf $APKG_PKG_DIR/etc/RoonServer.conf
		# cp -af $APKG_TEMP_DIR/* $APKG_PKG_DIR/etc/.
		# post upgrade script here (restore data)
		;;
	*)
		;;

esac

exit 0
