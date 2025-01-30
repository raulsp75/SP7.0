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
	read -p "Introduce tu edad: " edad
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
#	6)
#	7)
#	8)
#	9)
#	10)
#	11)
#	12)
#	13)
#	14)
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
