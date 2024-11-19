#!/bin/sh

supervisord -c /home/app/supervisord.conf 

exec "$@"