# Linux From Scratch in Docker container

This image created by this https://github.com/EvilFreelancer/docker-lfs-build builder
for people who want to begin with BLFS but do not want spent time to LFS compilation.
You can use it as a complete system for any of your ideas.

ISO and bzipped ramdisk here https://github.com/EvilFreelancer/docker-lfs-build/releases/tag/8.3

Docker container here https://hub.docker.com/r/evilfreelancer/lfs/

## How to use

You need download image form Docker Hub

    docker pull evilfreelancer/lfs

Then run it

    docker run -ti evilfreelancer/lfs /bin/bash

### Via `docker-compose`

```yml
version: '2'

services:
  lfs:
    restart: unless-stopped
    privileged: true
    image: evilfreelancer/lfs
    entrypoint: ["sleep", "inf"]
```

## How to help

If you found some bugs or/and if you want to suggest something, you can put your issue [here](https://github.com/EvilFreelancer/docker-lfs/issues).

## Enjoy your day!
