# redex-docker
A docker image for compiling and running redex

# Download
```bash
docker pull marukamikun/redex
```

# Runing redex
```bash
docker run -it --rm -v `pwd`\:/redex marukamikun/redex app.apk
```

# Interactive
redex is the default command for the container. If you need to debug and use bash you can over
ride the default command with `--entrypoint` 
```bash
docker run -it --rm --entrypoint=/bin/bash -v `pwd`\:/redex marukamikun/redex
```

# Reference 
The tools shell scrips are from https://github.com/appunite/docker
