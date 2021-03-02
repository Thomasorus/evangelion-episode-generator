#!/bin/sh

# Kantan 簡単 (simple, easy) - A set of bash scripts to launch a web server, watch files and launch build commands.
#
# Please take the time to configure the script
#
# The text printed each time you save (probably don't touch this):
FILENAME=$(echo -e "\033[1;33m%w%f\033[0m written")
# The key combination to refresh your browser:
KEY="CTRL+F5" 
 # The browser you use (currently only firefox is supported):
BROWSER="firefox" 
 # The folder or file you want to watch:
LOCATION="./demo"
# The server type you want to use (use the ones provided or create your own):
SERVER_TYPE="python" 
# The folder you want to serve with the server
DIST="."
# The build command you want to use (ex: npm run dev) or leave empty if you just want to refresh the page:
BUILD=""


case $SERVER_TYPE in
    "php")
        echo "PHP SERV"
        cd $DIST && php -S localhost:8000 index.php & cd ./../ &
    ;;
    "node")
        echo "NODE SERV"
        node nodeserver.mjs &
    ;;
    "python")
        echo "PYTHON SERV"
        python3 -m http.server 8000 -d $DIST &
    ;;
esac

# ./${SERVER_TYPE}server.sh
$BROWSER --new-window  http://localhost:8000/
sleep 0.1
WINDOW=$(xdotool search --name ${BROWSER} getactivewindow)

while inotifywait -qre close_write --format "$FILENAME" ${LOCATION}
do
    ${BUILD}
    xdotool windowraise $WINDOW
    xdotool key ${KEY}
done


