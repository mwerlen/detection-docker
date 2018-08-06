docker run \
    --cap-add SYS_ADMIN \
    --cap-add SYS_PTRACE \
    --security-opt apparmor:unconfined \
    -it \
    --rm \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --volume `pwd`/markerDetector:/usr/local/src/markerDetector \
    --volume `pwd`/visiona:/usr/local/src/visiona \
    --name detection mwerlen/detection:latest \
    /bin/bash
