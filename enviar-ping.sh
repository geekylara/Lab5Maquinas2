#!/bin/bash

read -p “Digite el numero del servidor a hacer ping” server_addr
ping -c 5 $server_addr 2>1 /dev/null || echo “Servidor caido”

echo “”
exit
