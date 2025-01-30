#!/bin/bash

#Verificar si el archivo metido por parametro existe
#Si -z=no existe $1=el primer archivo que metes por parametro
#Se imprime el echo por pantalla
if [ -z $1 ]; then
  echo "El archivo no existe"
  exit
#Si !=No -z=no existe $2=segundo archivo de parametro
#Se imprime el echo
elif [ ! -z $2 ]; then
  echo "No se pueden poner más de un fichero/directorio"
  exit
fi

#Asignamos a la variable ruta que find=filtre /=en todo el sistema la ruta de $1
#Y el 2>/dev/null esque los valores que den error con los meta en el archivo /dev/null que sirve para eso
ruta=$(find / -name $1 2>/dev/null)

#Si !=no -f=es un fichero que se imprima el echo
if [ ! -f $ruta ]; then
  echo "El archivo no es un fichero"
  exit
fi

fecha=$(date +"%d/%m/%Y-%I:%M:%S")

while IFS= read linea; do

#Creamos la variable login para que por cada línea coja la 4 columna
   login=$(echo $linea | awk -F ":" '{print $4}')

#Si en el fichero de usuarios | quitamos la union de : y cogemos la 1 columna | filtramos con el -w que tiene que ser exacto el nombre de login
#Toda la condicion si la ponemos entre un $() si queremos el valor
   if [[ $(cat /etc/passwd | awk -F ":" '{print $1}' | grep -w $login ) ]]; then
       echo "El usuario $login existe."
#Si el usuario no existe que la siguiente línea
#Explicación de la línea:$fecha es la variable que hemos creado, $usu hemos creado la variable, El mensaje de Error y lo pasamos al directorio /var/log/bajaerror.log
#La variable usu imprime la linea y cambia los : por - y colocamos cada columna en la posicion que quieras
   else
      usu=$(echo $linea | awk 'BEGIN{FS=":";OFS="-"} {print $4,$1,$2,$3}')
      echo "$fecha-$usu-ERROR:login no existe en el sistema" >> /var/log/bajaerror.log
      echo "Lo usuarios que no existen han sido traspasados al archivo /var/log/bajaerror.log"

fi
done < $ruta


