# docker-ubuntu-vivado
Dockerfile to create a Vivado 2018.3 installation under Ubuntu.
Modified from <https://github.com/phwl/docker-vivado>.


To build:

```bash
docker image build -t my/vivado:2018.3 .
```

To run:
```bash
docker run -it --rm \
-v $PWD:/mnt -w /work \
-e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/root/.Xauthority  \
my/vivado:2018.3 vivado
```
