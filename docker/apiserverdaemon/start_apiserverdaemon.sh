sudo docker run -d -p 8080:8080 --link fgdb:fgdb -v $HOME/fgVolumes/iosandbox:/tmp/fgiosandbox --name apiserverdaemon apiserverdaemon
