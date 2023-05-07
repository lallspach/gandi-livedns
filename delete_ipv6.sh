#!/bin/sh
#
# Delete a zone record using Gandi's LiveDNS.

# prevent shell to expand wildcard record
set -f

API="https://dns.api.gandi.net/api/v5/"
IP_SERVICE="http://me.gandi.net"

for RECORD in ${RECORD_LIST//;/ } ; do
  if [ "${RECORD}" = "@" ] || [ "${RECORD}" = "*" ]; then
    SUBDOMAIN="${DOMAIN}"
  else
    SUBDOMAIN="${RECORD}.${DOMAIN}"
  fi

  CURRENT_IPV6=$(dig AAAA ${SUBDOMAIN} +short)
  if [ -z "${CURRENT_IPV6}" ] ; then
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [INFO] No DNS AAAA record for ${RECORD}. Nothing to do."
    continue
  fi

  status=$(curl -s -w %{http_code} -o /dev/null -XDELETE -d \
    -H"X-Api-Key: ${APIKEY}" \
    "${API}/domains/${DOMAIN}/records/${RECORD}/AAAA")
  if [ "${status}" = '201' ] ; then
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [OK] Delete ${RECORD}"
  else
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [ERROR] API POST returned status ${status}"
  fi
done
