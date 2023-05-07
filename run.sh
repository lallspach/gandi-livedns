#!/bin/sh

if [[ -z "${APIKEY}" || -z "${RECORD_LIST}" || -z "${DOMAIN}" ]]; then
  echo "[ERROR] Mandatory variable APIKEY, DOMAIN or RECORD_LIST not defined."
  exit 1
fi

FAILURE_IPV6=0

while true; do
  if [ "${SET_IPV4}" = 'yes' ] ; then
    update_ipv4.sh
  fi
  if [ "${SET_IPV6}" = 'yes' ] ; then
    update_ipv6.sh
	FAILURE_IPV6=`expr $FAILURE_IPV6 + $?`
	if [ $FAILURE_IPV6 -ge 5 ]; then
	   delete_ipv6.sh
	   FAILURE_IPV6=0
	fi
  fi
  sleep ${REFRESH_INTERVAL} & wait
done