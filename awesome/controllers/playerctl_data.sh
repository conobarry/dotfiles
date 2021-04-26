#!/usr/bin/env sh

playerctl status && playerctl metadata | awk -F':' '{ print sub(/[:blank:]/, ":", $2) }'
