#!/bin/sh
### BEGIN INIT INFO
# Provides:          Jellyfin server
# Short-Description: Start or stop the Jellyfin server.
### END INIT INFO

PKG_NAME="Jellyfin"
PKG_DIR=/usr/local/AppCentral/Jellyfin
PID_FILE="$PKG_DIR/$PKG_NAME.pid"
CONFIG_DIR="$PKG_DIR/config"
REPOS_DIR="$PKG_DIR/repository"
# DAEMON="/usr/local/bin/python2.7"
# DAEMON_OPTS="LazyLibrarian.py -d --datadir $PKG_DIR/config --config $PKG_DIR/config/config.ini --pidfile $PID_FILE" 
# DAEMON_PACKAGE="/usr/local/AppCentral/python/lib/python2.7/site-packages" #change according to daemon version used
URL="https://github.com/jellyfin/jellyfin.git"
URL2="git://github.com/jellyfin/jellyfin.git"



CheckPkgRunning() { #Is the PKG already running? if so, exit the script
	if [ -f $PID_FILE ]; then
		#grab pid from pid file
		Pid=$(/bin/cat $PID_FILE)
		if [ -d /proc/$Pid ]; then
			/bin/echo " $PKG_NAME is already running" 
			exit 1
		fi
	fi
	#ok, we survived so the PKG should not be running
}

Update() {
      	/bin/echo -n " Updating from github..."
	[ -d $PKG_DIR/$PKG_NAME ] || git clone $URL $PKG_DIR/$PKG_NAME || git clone $URL2 $PKG_DIR/$PKG_NAME
	cd $PKG_DIR/$PKG_NAME
	/usr/local/bin/git reset --hard
	/usr/local/bin/git pull
}

StartPkg(){ #starts the PKG
	/bin/echo -n "Starting $PKG_NAME"
	cd $PKG_DIR/$PKG_NAME
	${DAEMON} ${DAEMON_OPTS}
	/bin/echo " Done ($(/bin/date))"
}

ShutdownPkg() { #kills a proces based on a PID in a given PID file
	if [ -f $PID_FILE ]; then
		#grab pid from pid file
		Pid=$(/bin/cat $PID_FILE)
		i=0
		/bin/kill $Pid
		/bin/echo -n " Waiting for ${PKG_NAME} to shut down: "
		while [ -d /proc/$Pid ]; do
			sleep 1
			let i+=1
			/bin/echo -n "$i, "
			if [ $i = 45 ]; then
				/bin/echo -n " Tired of waiting, killing ${PKG_NAME} now"
				/bin/kill -9 $Pid
				/bin/rm -f $PID_FILE
				/bin/echo " Done ($(/bin/date))"
				exit 1
			fi
		done
		/bin/rm -f $PID_FILE
		/bin/echo "Done ($(/bin/date))"
	else
		/bin/echo "${PKG_NAME} is not running? ($(/bin/date))"
	fi
}

case "$1" in
	start)
		/bin/echo "$PKG_NAME prestartup checks... ($(/bin/date))"	
		CheckPkgRunning  #Check if the PKG is not running, else exit
		Update     #Git Pull.
		StartPkg	 #Start the PKG... (finaly ;) )
	
	;;
	stop)
		/bin/echo "Shutting down ${PKG_NAME} at $(/bin/date)... "
		ShutdownPkg 	#shutdown the package
	;;
	restart)
		echo "Restarting $PKG_NAME"
		$0 stop
		$0 start
	;;
	*)
		echo "Usage: $0 {start|stop|restart}"
esac

exit 0

