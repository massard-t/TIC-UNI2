#!/bin/bash

{
  echo "\$ModLoad imudp"
  echo "\$UDPServerRun 514"
  echo "\$template Haproxy,\"%msg%\n\""
  echo "local0.=info -/var/log/haproxy.log;Haproxy"
  echo "local0.notice -/var/log/haproxy-status.log;Haproxy"
  echo "### keep logs in localhost ##"
  echo "local0.* ~"
} > /etc/rsyslog.d/haproxy.conf

/etc/init.d/rsyslog restart
