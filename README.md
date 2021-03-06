pharo-vnc-supervisor
========

A Docker image for [Pharo Smalltalk](http://www.pharo-project.org/ "Pharo"). Especially suitable for web application development and delivery.

- Pharo process is daemonized by supervisord.
- Debuggable via VNC.
- Web browsers (Firefox and Chronium) are installed.

## Usages ##

```bash
docker run --name my_pharo -d -p 5901:5901 -p 6901:6901 mumez/pharo-vnc-supervisor
```

You can access the running pharo image via VNC client or web browser.
(the default password is 'vncpassword')

- VNC client:  `yourhost:5901`
- Web browser: `http://yourhost:6901/?password=vncpassword`

### How to start with a customized Pharo image

1. Place your customized Pharo image to your docker-host data directory (For example, `$HOME/docker/pharo/data`).
2. Use `docker run` `-v` option to mount the data direcotry.

```bash
docker run --name my_pharo -d -p 5901:5901 -p 6901:6901 \
	-v=$HOME/docker/pharo/data:/root/data \
	mumez/pharo-vnc-supervisor
```

### How to change default Pharo image version 

By default, Pharo 6.1 will be installed to the docker image. You can specify other versions when building a docker image.

```bash
docker build -t pharo70-vnc-supervisor --build-arg PHARO_IMAGE_VERSION=70 .
docker run --name my_pharo70 -d -p 5901:5901 -p 6901:6901 pharo70-vnc-supervisor
```

## Settings ##

You can change these settings via `docker run` `-e` option.

### Pharo related environment variables

```bash
PHARO_SUPERVISOR_LOG_NAME=pharo-supervisord.log
PHARO_IMAGE=Pharo.image
PHARO_START_SCRIPT=
PHARO_MODE=gui
```

### VNC related environment variables

Please see [ubuntu-icewm-vnc](https://hub.docker.com/r/consol/ubuntu-icewm-vnc/).
