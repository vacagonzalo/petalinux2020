#!/bin/bash
docker run -ti -e DISPLAY=$DISPLAY --net="host" --name="petalinux" --hostname="petalinux" -v /home/gonzalo/workspace/:/home/vivado/workspace petalinux:2020.1 /bin/bash
