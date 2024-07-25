# Crops (Docker Edition)

This is a Dockerized version of [Crops](https://github.com/soranosita/crops).

## Usage

This image is different in that it holds the container open even when it's not doing anything. This works better for my setup personally.

## Binary

I've added a binary named `crops` inside the image for convenience. So instead of running `python3 main.py -h`, you can just run `crops -h`.

### Configuration Directory

This should be writable by the docker user. It's where your OPS and RED credentials will be stored.

### Torrents Directory (important)

This is where your existing torrent files are located.

In my case, I've pointed it to the directory that holds the torrents that are currently in my client. For Deluge, this is called the `state` directory. For qBittorrent, this is the `BT_Backup` directory. Do what you will here, but it's worked for me.

### Output Directory

This is where you want to store the newly created torrents for adding to your torrent client

## Installation

### Docker

```bash
docker run \
  --name crops-docker \
  -v /host/path/to/config:/config \
  -v /host/path/to/output:/output \
  -v /host/path/to/torrents:/torrents \
  ghcr.io/kieraneglin/crops-docker:latest
```

Then I interface with it like `docker exec -it crops-docker bash` and run the commands like `crops -h` from there.

### Docker Compose

Untested

```yaml
services:
  crops-docker:
    volumes:
      - /host/path/to/config:/config
      - /host/path/to/output:/output
      - /host/path/to/torrents:/torrents
    image: ghcr.io/kieraneglin/crops-docker:latest
```

Then you can interface with it like `docker-compose exec crops-docker bash` and run the commands like `crops -h` from there.

### Unraid

Create a new container in Unraid, enable "Advanced View" in the upper right, then add the following settings:

- **Name**: `crops-docker`
- **Repository**: `ghcr.io/kieraneglin/crops-docker:latest`
- **Icon URL**: `https://user-images.githubusercontent.com/113065340/189463044-5b4e9b84-c778-4639-818d-4cd638312390.png`
- **Extra Parameters**: `--user "crops:crops"`
- **Console shell command**: `bash`

Then add the following paths (volumes):

**Config Directory**:

- **Container Path**: `/config`
- **Host Path**: `/mnt/user/appdata/crops-docker`

**Output Directory**:

- **Container Path**: `/output`
- **Host Path**: `/mnt/user/your/output/directory`

**Torrents Directory**:

- **Container Path**: `/torrents`
- **Host Path**: `/mnt/user/your/torrents/directory`

For torrents, see the note above about where to point this. I use `/mnt/user/appdata/binhex-delugevpn/state/` but yours is likely to be different.
