#!/bin/bash

plik="$1"

if [ -z "$plik" ] || [ ! -f "$plik" ] || [ ! -s "$plik" ]; then
	read -p "Prosze podac nazwe pliku: " plik
	if [ -z "$plik" ] || [ ! -f "$plik" ] || [ ! -s "$plik" ]; then
		echo "Nie ma takiego pliku lub jest on pusty!"
		exit 1
	fi
fi

echo "ANALIZATOR LOGOW"
echo "-----"

nieudane_logowania=$(cat "$plik" | grep -w "FAILED")
ile_nieudanych_logowan=$(echo "$nieudane_logowania" | grep -c "FAILED")

if [ "$ile_nieudanych_logowan" -eq 0 ]; then
	> podejrzane.txt
	echo "W tym pliku nie ma nieudanych logowan"
	exit 0
fi

read -p "Prosze podac maksymalny limit nieudanych prob logowan dla jednego adresu IP (liczba calkowita, minimum 0): " limit

if ! echo "$limit" | grep -qE "^[0-9]+$"; then
	echo "limit musi byc liczba calkowita, minimum 0"
	exit 1
fi

echo "Laczna liczba nieudanych prob logowan: $ile_nieudanych_logowan"

adres_ip=$(echo "$nieudane_logowania" | cut -d' ' -f4)
proby_na_adres=$(echo "$adres_ip" | sort | uniq -c)
ranking=$(echo "$proby_na_adres" | sort -nr)
podejrzane=$(echo "$ranking" | awk -v p=$limit '$1>=p')

if [ -z "$podejrzane" ]; then
	> podejrzane.txt
	echo "Zaden adres IP nie przekroczyl progu limit"
	exit 0
else
	echo "$podejrzane" > podejrzane.txt
	echo "Podejrzane adresy ktore przekroczyly limit lub sa rowne jemu: "
	echo -e "\e[31m$podejrzane\e[0m"
	echo "Wszystkie podejrzane adresy sa zapisane w pliku podejrzane.txt"
	exit 0
fi
