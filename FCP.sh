#!/bin/sh

#File comandi principale FCP.sh

#Controllo il numero di parametri: deve essere maggiore o uguale a 4
case $# in
0|1|2|3)	echo Errore: sono necessari almeno 4 parametri, $# sono pochi
		exit 1;;
*)		echo OK passati $# parametri;;
esac

#Controllo primo parametro: deve essere una semplice stringa
case $1 in
*/*)	#Se contiene uno / in qualunque posizione la stringa non è valida
	echo Errore: $1 non deve contenere /
	exit 2;;
*)	;; #Stringa corretta
esac

string1=$1 #salvo il primo parametro in una variabile di nome string1

#Controllo secondo parametro: deve essere una semplice stringa
case $2 in
*/*)	#Se contiene uno / in qualunque posizione la stringa non è valida
	echo Errore: $2 non deve contenere /
	exit 3;;
*)	;; #Stringa corretta
esac

string2=$2 #salvo il secondo parametro in una variabile di nome string2

#Ora che ho salvato i primi due parametri in altre due variabili posso fare lo shift eliminando i primi due parametri (stringhe)
shift
shift

#Eliminati i primi due parametri precedenti, ora rimangono solo le H gerarchie

#A questo punto verifico che le gerarchie abbiano nomi assoluti e che siano directory

for abs
do
	case $abs in
	/*)	if test ! -d $abs -o ! -x $abs
		then
			echo $abs non directory o non traversabili
			exit 4
		fi;;
	*)	echo $abs non nome assoluto; exit 5;;
	esac
done

#Finiti i controlli sui parametri

#Settaggio ed esportazione della variabile PATH
PATH=`pwd`:$PATH
export PATH

#Variabile che contiene il numero totale di file trovati con estensione string1
Somma1=0

#Variabile che contiene il numero totale di file trovati con estensione string2
Somma2=0

#Creazione del file temporaneo che contiene nomi file con estensione string1
> /tmp/completeNames1$$

#Creazione del file temporaneo che contiene nomi file con estensione string2
> /tmp/completeNames2$$

#Si passa alle H fasi

for abs
do
	#Invocazione file comandi ricorsivo con parametri la gerarchia corrente, le due stringhe semplici e i file temporanei
	FCR.sh $abs $string1 $string2 /tmp/completeNames1$$ /tmp/completeNames2$$
done

#Terminate le ricerche ricorsive, cioè le H fasi

Somma1=`wc -l < /tmp/completeNames1$$`
Somma2=`wc -l < /tmp/completeNames2$$`

echo Il numero di file che terminano con $string1 è $Somma1
echo Il numero di file che terminano con $string2 è $Somma2

if test $Somma1 -le $Somma2
then
	echo "Laura scegliere un numero intero M compreso fra 1 e $Somma1"
	read M
	#Controllo se M è un numero intero e strettamente positivo
	case $M in
	*[!0-9]*)	echo $M non numerico o negativo
			rm /tmp/completeNames1$$
			rm /tmp/completeNames2$$
			exit 6;;
	*)		#Se il numero è intero e positivo controllo che sia compreso fra 1 e Somma1
			if test $M -lt 1 -o $M -gt $Somma1
			then
				echo $M non compreso fra 1 e $Somma1, non faccio nulla
				rm /tmp/completeNames1$$
				rm /tmp/completeNames2$$
				exit 7
			fi;;
	esac
	echo $M-esimo file che termina con $string1
	head -$M /tmp/completeNames1$$ | tail -1
	echo $M-esimo file che termina con $string2
	head -$M /tmp/completeNames2$$ | tail -1
else
	#Se Somma1 è maggiore di Somma2 non faccio niente
	echo Siccome $Somma1 maggiore di $Somma2 non faccio nulla
fi

#Rimozione dei file temporanei
rm /tmp/completeNames1$$
rm /tmp/completeNames2$$
