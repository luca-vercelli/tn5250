#
# Regular cron jobs for the tn5250 package
#
0 4	* * *	root	[ -x /usr/bin/tn5250_maintenance ] && /usr/bin/tn5250_maintenance
