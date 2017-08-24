#!/bin/bash
nmap $1 -p 85 --open  | grep -B 1 "Host is up" | sed -e '/^Host.*$/d' -e 's/^[^0-9]*//' -e '/^$/d'
