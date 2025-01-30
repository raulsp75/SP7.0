#!/bin/bash

numFac=1

for ((i=1; i<=$1; i++)); do
#Cuando se realicen operaciones se pone doble parentesis y $
#Ejemplo: variable=$((1+2))
  numFac=$(($numFac*$i))
  done

echo "El numero factorial de $1 es $numFac"
