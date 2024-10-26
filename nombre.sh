#!/bin/bash

read -p “Puedes escribir tu nombre:? “
echo “Hola $REPLY”
echo “Decide si cara o cruz? “

read lado

if [ $lado = “cara” ]; then
    echo “has acertado en cara”
else
    echo “has acertado en cruz”
fi

exit 0
