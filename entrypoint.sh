#!/bin/sh

mkdir -p /etc/xray /usr/share/xray/

HTTP_PORT=${HTTP_PORT:-10000}

if [ ! -f /usr/bin/xray ]
then
	# download
	wget -qO- https://api.github.com/repos/xtls/xray-core/releases/latest | grep linux-64 | grep browser_download_url | cut -d '"' -f4 | xargs wget
	awk '/MD5=/{print $2, "Xray-linux-64.zip"}' Xray-linux-64.zip.dgst > Xray-linux-64.zip.md5
	md5sum -c Xray-linux-64.zip.md5 && { echo "md5 check pass"; } || { echo "md5 check fail"; exit 1; }

	# intall
	unzip Xray-linux-64.zip && mv xray /usr/bin/ && mv geosite.dat geoip.dat /usr/share/xray/
fi

# config
cat <<EOF > /etc/xray/config.json
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": $HTTP_PORT,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$UUID"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "xhttp",
        "security": "none",
        "xhttpSettings": {
          "path": "/${XHTTP_PATH}",
          "mode": "auto"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

# overwrite full file
[ "$CONFIG_JSON" ] && echo "$CONFIG_JSON" > /etc/xray/config.json

# run
/usr/bin/xray -c /etc/xray/config.json
