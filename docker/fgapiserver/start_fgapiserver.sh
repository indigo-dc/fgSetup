sudo docker run -d -p 80:80 --link fgdb:fgdb -v $HOME/fgVolumes/apps:/app/apps -v $HOME/fgVolumes/iosandbox:/tmp/fgiosandbox --name fgapiserver fgapiserver
