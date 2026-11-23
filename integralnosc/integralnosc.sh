#!/bin/bash

wzorzec="/home/kuba/integralnosc/wzorzec.txt"
pliki=("/etc/hosts" "/etc/fstab" "/etc/ssh/ssh_config")

tryb="$1"

if [ ! "$tryb" = "init" ] && [ ! "$tryb" = "check" ]; then
	echo "Uzycje: sudo ./integralnosc.sh init|check"
	exit 1
fi

if [ "$EUID" -ne 0 ]; then
	echo "Tylko root moze uruchomic ten program"
	exit 1
fi

if [ "$tryb" = "init" ]; then
	> "$wzorzec"
	licznik=0
	for plik in "${pliki[@]}"; do
		if [ -f "$plik" ]; then
			sha256sum "$plik" >> "$wzorzec"
			licznik=$((licznik+1))
		else
			echo "[!!!]: brak pliku $plik"
		fi
	done
	echo "Zapisano: $licznik plikow"
	exit 0
fi

if [ ! -s "$wzorzec" ] || [ ! -f "$wzorzec" ]; then
	echo "Pierw program musi zostac uruchomiony w trybie init"
	exit 1
fi

sprawdzone=0
zmiany=0

while read suma sciezka; do
	sprawdzone=$((sprawdzone+1))
	if [ ! -f "$sciezka" ]; then
		echo "[!!!]: plik zostal usuniety: $sciezka"
		zmiany=$((zmiany+1))
	else
		nowa_suma=$(sha256sum "$sciezka" | cut -d' ' -f1)
		if [ "$nowa_suma" = "$suma" ]; then
			echo "OK: $sciezka"
		else
			echo "[!!!]: Zmianiono zawartosc pliku: $sciezka"
			zmiany=$((zmiany+1))
		fi
	fi
done < "$wzorzec"

echo "Sprawdzono $sprawdzone plikow"
echo "Zmiany: $zmiany"
if [ "$zmiany" -gt 0 ]; then
	exit 1
fi
exit 0
