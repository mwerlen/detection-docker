docker run \
    --cap-add SYS_ADMIN \
    --security-opt apparmor:unconfined \
    -it \
    --rm \
    --volume /home/mwerlen/projects/detection-docker/visiona:/usr/local/src/visiona \
    --name detection mwerlen/detection:latest \
    /bin/bash
