# minecraft
A small modification to popular minecraft docker image itzg/minecraft-server so I can specify a tgz to untar into the world folder.
This allows me to run my worlds from a tmpfs which is much faster than a disk.

LATEST must point to a tgz file.

Here is an example of how I use this.
```
version: "3"

services:
  mc:
    image: biosludge/minecraft
    ports:
      - "25566:25565"
    volumes:
      - "data:/data"
      - "./backup:/backup:ro"
      - "./config:/config"
    environment:
      EULA: "TRUE"
      ENABLE_RCON: "true"
      RCON_PASSWORD: "somepass"
      LATEST: "/backup/latest.tgz"
      RCON_PORT: 28016
      COPY_CONFIG_DEST: "/data"
    restart: always
  backup-mc:
    image: itzg/mc-backup
    environment:
      BACKUP_INTERVAL: "10m"
      PRUNE_BACKUPS_DAYS: "14"
      RCON_HOST: "mc"
      RCON_PORT: "28016"
      RCON_PASSWORD: "somepass"
      EXLUDES: "cache,logs,jar,gz,tgz,xml"
      BACKUP_METHOD: "tar"
      DEST_DIR: "/backup"
      LINK_LATEST: "TRUE"
    volumes:
    - "data:/data:ro"
    - "./backup:/backup"
    restart: always

volumes:
  data:
    driver_opts:
      type: tmpfs
      device: tmpfs
```
	
Using a tmpfs comes with risks that you could lose world data since the last backup was ran if the tmpfs disk is destroyed.

This is use at your own risk.