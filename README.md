# lukaszlach / kali-desktop

[![Docker pulls](https://img.shields.io/docker/pulls/lukaszlach/kali-desktop.svg?label=docker+pulls)](https://hub.docker.com/r/lukaszlach/kali-desktop)
[![Docker stars](https://img.shields.io/docker/stars/lukaszlach/kali-desktop.svg?label=docker+stars)](https://hub.docker.com/r/lukaszlach/kali-desktop)

Kali Desktop provides [Docker images](https://hub.docker.com/r/lukaszlach/kali-desktop/) with [Kali Linux](https://www.kali.org/) and a VNC server. This project allows you to pick Kali Linux version, favorite desktop environment, and run it on any system - Linux, MacOS or Windows - to access remotely and execute commands using a VNC client **or a web browser**.

![](https://user-images.githubusercontent.com/5011490/44137821-0af8d0e8-a072-11e8-8962-cd21a1283a04.png)

* Kali Linux 2018.2
    * Xfce - `:xfce`
    * LXDE - `:lxde`
    * KDE - `:kde`
* Kali Linux 2018.2 with Top10 tools pre-installed
    * Xfce - `:xfce-top10`

## Running

All required services and dependencies are inside the Docker images so only web browser and one command are needed to start `kali-desktop`:

![](https://user-images.githubusercontent.com/5011490/44146922-0dff2d6c-a092-11e8-875a-2e2ba16dd0bd.gif)

However the most common case is  `kali-desktop` running with host network in privileged mode, so tools like network sniffing work properly and with full speed without Docker network filtering the traffic. See all available Docker image tags on [Docker Hub](https://hub.docker.com/r/lukaszlach/kali-desktop/tags/).

```bash
# run on host network
docker run -d --network host --privileged lukaszlach/kali-desktop:xfce

# run on Docker network
docker run -d -p 5900:5900 -p 6080:6080 --privileged lukaszlach/kali-desktop:xfce
```

After the container is up you can access Kali Linux Desktop under http://localhost:6080, the hostname can differ if you are doing this on a remote server. `vnc_auto.html` will connect you automatically, `vnc.html` allows some connection tuning.

> Docker for Mac works inside a small virtual machine which IP you must use to access the exposed ports or use service like [Dinghy](https://github.com/codekitchen/dinghy).

If you want to customize the container behavior you can pass additional parameters:

```bash
docker run -d \
    --network host --privileged \
    -e RESOLUTION=1280x600x24 \
    -e USER=kali \
    -e PASSWORD=kali \
    -e ROOT_PASSWORD=root \
    -v /home/kali:/home/kali \
    --name kali-desktop \
    lukaszlach/kali-desktop:xfce
```

Run parameters:

* `--network host` - optional but recommended, use the host network interfaces, if you do not need to use this option you have to manually publish the ports by passing `-p 5900:5900 -p 6080:6080`
* `--privileged` - optional but recommended
* `-e RESOLUTION` - optional, set streaming resolution and color depth, default `1280x600x24`
* `-e USER` - optional, work as a user with provided name, default `root`
* `-e PASSWORD` - optional, provide a password for USER, default `kali`
* `-e ROOT_PASSWORD` - optional, provide password for root, default `root`
* `-v /home/kali:/home/kali` - optional, if USER was provided it is a good idea to persist user settings, work files and look-and-feel

Exposed ports:

* `5900/tcp` - VNC
* `6080/tcp` - noVNC, web browser VNC client

## Extending

Create `Dockerfile.xfce-web` and modify the image as desired, below example installs Kali Linux web application assessment tools:

```
FROM lukaszlach/kali-desktop:xfce

RUN apt-get update && \
    apt-get install -y kali-linux-web \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

Build the image:

```bash
docker build \
    -f Dockerfile.xfce-web \
    -t kali-desktop:xfce-web \
    .
```

Run the image:

```bash
docker run --network host --privileged kali-desktop:xfce-web
```

## Licence

MIT License

Copyright (c) 2018 Łukasz Lach <llach@llach.pl>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.