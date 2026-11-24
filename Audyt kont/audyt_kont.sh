#!/bin/bash

konta="/etc/passwd"
hasla="/etc/shadow"

problemy=0

if [ "$EUID" -ne 0 ]; then
	echo "Tylko root moze uruchomic ten program"
	exit 1
fi

if [ ! -f "$konta" ] || [ ! -f "$hasla" ]; then
	echo "Brak pliku $konta lub $hasla"
	exit 1
fi

echo "AUDYT KONT"
echo "-----"

konta_uid0=$(awk -F: '$1!="root" && $3==0 {print $1}' "$konta")

if [ -z "$konta_uid0" ]; then
	echo "OK: brak kont z UID rownym 0 oprocz root"
else
	while read nazwa; do
		echo "[!!!]: $nazwa ma UID rowny 0"
		problemy=$((problemy+1))
	done <<< "$konta_uid0"
fi

konta_bez_hasel=$(awk -F: '$2=="" {print $1}' "$hasla")

if [ -z "$konta_bez_hasel" ]; then
	echo "OK: wszystkie konta maja ustawione haslo"
else
	while read nazwa; do
		echo "[!!!]: konto $nazwa nie ma ustawionego hasla"
		problemy=$((problemy+1))
	done <<< "$konta_bez_hasel"
fi

konta_z_powloka=$(awk -F: '$1!="root" && $3<1000 && $7!~/nologin|false/ {print $1}' "$konta")

if [ -z "$konta_z_powloka" ]; then
	echo "OK: brak kont z powloka logowania"
else
	while read nazwa; do
		echo "[!!!]: konto $nazwa ma powloke logowania"
		problemy=$((problemy+1))
	done <<< "$konta_z_powloka"
fi

duplikaty_uid=$(cut -d: -f3 "$konta" | sort | uniq -d)

if [ -z "$duplikaty_uid" ]; then
	echo "OK: brak kont z duplikatem w UID"
else
	while read uid; do
		echo "[!!!]: UID $uid zawieraja co najmniej 2 konta"
		problemy=$((problemy+1))
	done <<< "$duplikaty_uid"
fi

zwykle_konta=$(awk -F: '$3>=1000 && $3<65534 {print $1}' "$konta")

if [ -z "$zwykle_konta" ]; then
	echo "INFO: brak zwyklych kont"
else
	echo "INFO: Zwykle konta:"
	while read nazwa; do
		echo "  $nazwa"
	done <<< "$zwykle_konta"
fi

echo ""
echo "Podsumowanie"
echo "Znalezione problemy: $problemy"
echo ""

if [ "$problemy" -eq 0 ]; then
	exit 0
fi
exit 1
