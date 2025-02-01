#!/bin/bash
#Funcion del menú
menu() {
	echo "0. Salir"
	echo "1. Factorial"
	echo "2. Bisiesto"
	echo "3. Configurar Red"
	echo "4. Adivina"
	echo "5. Edad"
	echo "6. Fichero"
	echo "7. Buscar"
	echo "8. Contar"
	echo "9. Privilegios"
	echo "10. Permisos Octal"
	echo "11. Romano"
	echo "12. Automatizar"
	echo "13. Crear"
	echo "14. Crear_2"
	echo "15. Reescribir"
	echo "16. Contusu"
	echo "17. Alumnos"
	echo "18. Quita_Blancos"
	echo "19. Lineas"
	echo "20. Analizar"
	echo "======================"
}

factorial() {
	numFac=1

	for ((i=1; i<=$1; i++)); do
	#Cuando se realicen operaciones se pone doble parentesis y $
	#Ejemplo: variable=$((1+2))
  		numFac=$(($numFac*$i))
  	done

	echo "El numero factorial de $1 es $numFac"
}

bisiesto() {
	#Abrimos un if y comparamos el numero del parametro con la condición de bisiesto
	if (( $1%4==0 && $1%100!=0 || $1%400==0 )); then
	  echo "El número $1 es un número bisiesto"

	else
	  echo "El número $1 no es bisiesto"

	fi
}

configurared() {
	#Confrimamos que los parametros existen
	if [[ -n $1 && -n $2 && -n $3 && -n $4 ]]; then
	  echo "Introduciendo parámetros..."

	else
	  echo "Faltan parámetros por añadir"
	exit
	fi
	#Introducimos los parametros en el archivo
	cat <<EOF > /etc/netplan/50-cloud-init.yaml
network:
    ethernets:
        enp0s3:
            dhcp4: no
            addresses: [$1/$2]
            routes:
              - to: default
                via: $3
            nameservers:
             addresses: [$4]
    version: 2
EOF
	#Aplicamos la configuración
	netplan apply
	if [ $? -ne 0 ]; then
	  echo "Las opciones proporcionadas no pueden ser aplicadas. Vuelva a intentarlo ejecutando el script"
	exit
	#Mostramos la configuración
	else
	  echo "==========================================================================="
	  echo "La configuración ha sido modificada con exito. Se la muestro a continuación:"
	  sleep 1
	  ip a
	fi
}

adivina() {
	#Declaramos las variables necesarias
	numAle=$(( RANDOM % 100 + 1 ))
	num=101
	intentos=0
	#Creamos un bucle hasta que encontremos el número que buscamos
	while (( $num != $numAle )); do
	  read -p "Introduce un número entre 1 y 100: " num
	  #Abrimos un if para comparar el valor
	  if (( $num < $numAle )); then
	    echo "El numero que has introducido es mayor que el número que buscas"
	    (( intentos ++ ))

	  elif (( $num > $numAle )); then
            echo "El numero que has introducido es menor que el número que buscas"
	    (( intentos ++))

	  else
	    (( intentos ++ ))
	  echo "Felicidades! Has acertado el $num es el correto. Numero de intentos = $intentos. "
	  fi
	done
}

edad(){
	#Le pedimos la edad del usuario
	read -p "Introduce tu edad: " edad
	#Metemos un if para saber la edad que tiene el usuario
	if (( $edad < 3 )); then
	  echo "Estas en la niñez"
	elif (( $edad <= 10 && $edad >= 3 )); then
	  echo "Estás en la infancia"
	elif (( $edad < 18 && $edad > 10 )); then
	  echo "Estás en la adolescencia"
	elif (( $edad < 40 && $edad >=18 )); then
	  echo "Estás en la juventud"
	elif (( $edad < 65 && $edad >=40 )); then
	  echo "Estás en la madurez"
	else
	  echo "Estás en la vejez"
	fi
}

fichero(){
	read -p "Seleccione el nombre del fichero que quiere buscar: (Ej: Fichero.txt) " fichero
	ruta=$(find / -name "$fichero" 2>/dev/null)
	tamano=$(ls -l "$ruta" | awk '{print $5}')
	file=$(file -b "$ruta")
	inodo=$(ls -i "$ruta" | awk '{print $1}')
	montaje=$(df raulmenu.sh | awk 'NR==2 {print $1}')
	echo "Esta es su ruta: $ruta"
	echo "Este es su tamaño: $tamano bytes"
	echo "Este es el tipo de archivo: $file"
	echo "Este es el inodo: $inodo"
	echo "Este es el punto de montaje: $montaje"
}

buscar(){
	read -p "Seleccione el nombre del fichero que quiere buscar: (Ej: Fichero.txt) " fichero
	existe=$(find / -name "$fichero" 2>/dev/null)
	if [[ -f "$existe" ]]; then
	  echo "El archivo este en este directorio: "$existe"."
          vocal=$(grep -o -i '[aeiou]' "$existe"| wc -l)
          echo "$fichero está tiene "$vocal" vocales"

	else
	  echo "Error. El archivo "$fichero" no existe en este equipo."
	fi
}

contar(){
	read -p "Selecciona un directorio para saber el numero de ficheros: " fichero
	numero=$( find "$fichero" -type f | wc -l)
	 echo "En el directorio "$fichero" hay "$numero" archivos."
}

privilegios(){
	if [[ $EUID -eq 0 ]] ; then
   	  echo "El usuario tiene privilegios administrativos (root)."
	elif  groups | grep -qw "sudo"; then
	  echo "El usuario tiene privilegios administrativos (sudo)."
	else
    	  echo "El usuario no tiene privilegios administrativos."
	fi
}

octal(){
	read -p "Seleccione la ruta absoluta de su directorio/archivo: (Ej:/home/raul/prueb.txt) " ruta
	permisos=$(stat -c "%#a" "$ruta")
	echo "Los permisos de ruta son: "$permisos""
}

#romano(){
#	read -p "Selecciona un numero entre el 1-200: " num
#	if [[ "$num" -gt 200 || "$num" -lt 1 ]]; then
#	  echo "El numero "$num" no está entre el 1-200"
#	else
#}

automatizar(){
	usus=$( ls /mnt/usuarios 2>/dev/null )

	if [[ -z "$usus" ]]; then
	  echo "El listado está vacío."

	else
	  for usu in $usus; do
	  	useradd "$usu"
	  	echo "El usuario "$usu" ha sido creado. "

		while IFS= read -r carpeta; do
	      		if [ -n "$carpeta" ]; then
			mkdir -p "/home/$usu/$carpeta"
			echo "Directorio creado: /home/$usu/$carpeta"
	      		fi
	   	 done < "/mnt/usuarios/$usu"
		rm "/mnt/usuarios/$usu"
		echo "La carpeta /mnt/usuarios/$usu ha sido eliminada"
	  done
	fi
}

crear(){
	if [[ ! -z $1  && ! -z $2 ]]; then
		truncate -s $2K $1
		echo "El archivo $1 ha sido creado con $2 kb"
		ls -lh "$1"

	elif [[ ! -z $1 ]]; then
		truncate -s 1024K $1
		echo "El archivo $1 ha sido creado con 1024 kb"
		ls -lh "$1"

	else
		truncate -s 1024K fichero_vacio
		echo "El archivo fichero_vacio ha sido creado con 1024 kb"
		ls -lh fichero_vacio
	fi
}

crear_2(){
	ficher="fichero_vacio"
        kb="1024"
        num=0

        if [ ! -z $1 ]; then
        	ficher=$1;
        fi

        if [ ! -z $2 ]; then
        	kb=$2;
        fi

        while [ -e $ficher ] && [ $num -lt 9 ]; do
        	((num++))
        	ficher="${ficher%[0-9]}$numf"
        done

        if [ $num -lt 9 ]; then
        	touch $ficher
        	truncate -s "${kb}K" $ficher

        else
       		echo "Limite alcanzado"

        fi


}

op=1

while [ $op != 0 ]; do
	#Mostrar el menu
	menu

	#Coger la opcion
	read -p "Selecione una opcion: " op

	case $op in
	  0)echo "Saliendo...";;
	  1)read -p "¿De qué numeros quieres su factorial?: " fac
	    factorial $fac;;
	  2)read -p "¿Que año quieres saber si es bisiesto?: " bisi
	    bisiesto $bisi;;
	  3)read -p "¿Qué dirección ip le quieres dar? (Ej:192.168.115.5): " ip
	    read -p "¿Qué dirección máscara le quiere dar? (Ej:24): " mascara
	    read -p "¿Qué puerta enlace le quiere dar? (Ej: 192.168.115.1): " puerta
	    read -p "¿Qué DNS le quiere dar? (Ej: 8.8.8.8): " DNS
	    configurared $ip $mascara $puerta $DNS;;
	  4)adivina;;
	  5)edad;;
	  6)fichero;;
          7)buscar;;
          8)contar;;
	  9)privilegios;;
	  10)octal;;
	  11)romano;;
          12)automatizar;;
	  13)read -p "Seleccione el nombre del archivo: " nombre
	     read -p "Seleccione el tamano del archivo en kb: " tamano
	     crear $nombre $tamano;;
	  14)read -p "Seleccione el nombre del archivo: " nombre
             read -p "Seleccione el tamano del archivo en kb: " tamano
             crear_2 $nombre $tamano;;
#	15)
#	16)
#	17)
#	18)
#	19)
#	20)
	  *) echo  "Opción no válida."
	esac

	if [ $op != 0 ]; then
	  read -p "Presiona Enter para continuar..."
	  echo "==================================="
	fi
done
#Apuntes Script
#Usa (( ... )) para operaciones matemáticas y condiciones numéricas.
#Usa [[ ... ]] para comparaciones de cadenas y condiciones más avanzadas.
#cat <<EOF inicia un bloque de texto, y todo lo que escribas después se mantiene tal cual, incluyendo saltos de línea y espacios.
#[ $? -ne 0 ] significa "si el código de salida no es 0" (o sea, si falló).
#(( intentos ++ ))  Con esta opercaion sumamos +1 a la variable intentos
