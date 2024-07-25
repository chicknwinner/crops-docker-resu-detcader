FROM python:3.11-slim-buster

ARG uid=1000
ARG gid=1000
ARG GITHUB_REPO="soranosita/crops"
ARG GITHUB_BRANCH="main"

WORKDIR /app

COPY docker_start /app/docker_start

RUN apt-get update \
  && echo "----- Downloading latest code" \
  && apt-get install -y curl zip \
  && curl -L https://github.com/$GITHUB_REPO/archive/refs/heads/$GITHUB_BRANCH.zip -o crops.zip \
  && unzip crops.zip \
  && mv crops-$GITHUB_BRANCH/src/* /app/ \
  && rm -rf crops.zip crops-$GITHUB_BRANCH \
  && echo "----- Installing python requirements" \
  && pip install --trusted-host pypi.python.org -r requirements.txt \
  && echo "----- Preparing config" \
  && mkdir -p /config /torrents /output \
  && rm /app/settings.json \  
  && echo "----- Creating executable" \
  && echo "#!/bin/bash\npython3 /app/main.py \$@" >/bin/crops \
  && chmod +x /bin/crops \
  && echo "----- Adding crops user and group and chown" \
  && groupadd -r crops -g $gid \
  && useradd --no-log-init -MNr -g $gid -u $uid crops \
  && chown crops:crops -R /app \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER crops:crops

CMD ["/app/docker_start"]
