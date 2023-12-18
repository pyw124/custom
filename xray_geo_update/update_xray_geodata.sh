bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install-geodata

LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')

GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/$LATEST_VERSION/geoip.dat"
GEOIP_CHECKSUM_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/$LATEST_VERSION/geoip.dat.sha256sum"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/$LATEST_VERSION/geosite.dat"
GEOSITE_CHECKSUM_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/$LATEST_VERSION/geoip.dat.sha256sum"

curl -m 15 -L -R -H "Cache-Control: no-cache" -o /tmp/geoip.dat.sha256sum $GEOIP_CHECKSUM_URL
if [[ $? == 0 ]]
then
  curl -m 15 -L -R -H "Cache-Control: no-cache" -o /tmp/geoip.dat $GEOIP_URL
  cd /tmp
  /usr/bin/sha256sum -c geoip.dat.sha256sum
  if [[ $? == 0 ]]
  then
    /usr/bin/cp -f /tmp/geoip.dat /usr/local/share/xray/geoip-enhanced.dat
  fi
fi

curl -m 15 -L -R -H "Cache-Control: no-cache" -o /tmp/geosite.dat.sha256sum $GEOSITE_CHECKSUM_URL
if [[ $? == 0 ]]
then
  curl -m 15 -L -R -H "Cache-Control: no-cache" -o /tmp/geosite.dat $GEOSITE_URL
  cd /tmp
  /usr/bin/sha256sum -c geosite.dat.sha256sum
  if [[ $? == 0 ]]
  then
    /usr/bin/cp -f /tmp/geosite.dat /usr/local/share/xray/geosite-enhanced.dat
  fi
fi

systemctl restart xray