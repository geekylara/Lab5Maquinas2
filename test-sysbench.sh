#!/bin/bash

# Script para realizar un test a la raspberry pi

# Preparar numero de pases
if [ -z $1 ]; then
    pasadas=1
else
    pasadas=$1
fi

# Comienzo del test
clear
sync
echo "Probando SYSBENCH en un script"

# Mostrar información del sistema
echo "Información del sistema:"
vcgencmd measure_temp
vcgencmd get_config int | grep arm_freq
vcgencmd get_config int | grep core_freq
vcgencmd get_config int | grep sdram_freq
vcgencmd get_config int | grep gpu_freq
printf "reloj sd="
grep "actual clock" /sys/kernel/debug/mmc0/ios 2>/dev/null | awk '{printf("%0.3f MHz", $3/1000000)}'
echo "\n"

echo "Ejecutando test de la CPU..."
for pase in `seq 1 $pasadas`; do
    if [ $pasadas -gt 1 ]; then
        echo "Pase $pase de $pasadas \n"
    fi
    sysbench --num-threads=4 --validate=on --test=cpu --cpu-max-prime=5000 run | grep 'total time:\|min:\|avg:\|max:' | tr -s [:space:]
    vcgencmd measure_temp
    echo "\n"
done

echo "\n"

echo "Ejecutando test de hilos..."
for pase in `seq 1 $pasadas`; do
    if [ $pasadas -gt 1 ]; then
        echo "Pase $pase de $pasadas \n"
    fi
    sysbench --num-threads=4 --validate=on --test=threads --thread-yields=4000 --thread-locks=6 run | grep 'total time:\|min:\|avg:\|max:' | tr -s [:space:]
    vcgencmd measure_temp
    echo "\n"
done

echo "\n"

echo "Ejecutando test de memoria..."
for pase in `seq 1 $pasadas`; do
    if [ $pasadas -gt 1 ]; then
        echo "Pase $pase de $pasadas \n"
    fi
    sysbench --num-threads=4 --validate=on --test=memory --memory-block-size=1K --memory-total-size=3G --memory-access-mode=seq run | grep 'Operations\|transferred\|total time:\|min:\|avg:\|max:' | tr -s [:space:]
    vcgencmd measure_temp
    echo "\n"
done

echo "\nFin del test"
exit 0
