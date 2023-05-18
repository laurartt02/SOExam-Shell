#!/bin/sh

#File comandi ricorsivo FCR.sh che salva i nomi dei file in file temporanei

cd $1 #mi sposto nella gerarchia corrente

#Esploro la gerarchia

for elem in *
do
	#Effettuo il controllo sui file leggibili
	if test -f $elem -a -r $elem
	then
		case $elem in
		*.$2)	#File che ha come estensione string1 e salvo sul corrispondente file temporaneo
			echo `pwd`/$elem >> $4;;
		*.$3)	#File che ha come estensione string2 e salvo sul corrispondente file temporaneo
			echo `pwd`/$elem >> $5;;
		esac #se il file non contiene le estensioni interessate ignoro e vado avanti
	fi
done

#Ricorsione di tutta la gerarchia
for elem in *
do
	#Verifico se è directory ed è traversabile
	if test -d $elem -a -x $elem
	then
		FCR.sh `pwd`/$elem $2 $3 $4 $5
	fi
done
