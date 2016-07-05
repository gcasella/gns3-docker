#!/bin/bash

case "$1" in
        start)
                /usr/bin/gns3server --config /opt/gns3/.config/gns3_server.conf --log /opt/gns3/.log/gns3_server.log --pid /opt/gns3/.pid/gns3.pid --controller --daemon; /bin/bash
                ;;
        status)
                ps -ef | awk '/gns3server/&&/python3/&&!/grep/ {print $9 " has been executed and is running on PID "$2}' || echo "GNS3 Server is not running. | Usage: $0 {start|status|restart}"
                exit 0
                ;;
        restart)
                echo "Restarting the GNS3 Server..."
                ps -ef | awk '/gns3server/&&/python3/&&!/grep/ {print $2}' | xargs kill && rm -rf /opt/gns3/.pid/gns3.pid
                sleep 3
                /usr/bin/gns3server --config /opt/gns3/.config/gns3_server.conf --log /opt/gns3/.log/gns3_server.log --pid /opt/gns3/.pid/gns3.pid --controller --daemon
                exit 0
                ;;
        update-check)
                PREVIOUS=$(/usr/bin/gns3server --version)
                echo "Checking for update..."
                sleep 2
                pip3 -q install gns3-server --upgrade
                NEW=$(/usr/bin/gns3server --version)
                if [ $PREVIOUS = $NEW ]; then
                        echo "New version $NEW detected, upgrading from $PREVIOUS -- Restarting GNS3"
                        echo
                        $0 restart
                        exit 0
                else
                        echo "Currently running version $PREVIOUS of GNS3 -- most up to date version"
                        exit 1
                fi
                ;;
        *)
                echo $"Usage: $0 {start|status|restart|update-check}"
                exit 1
esac
