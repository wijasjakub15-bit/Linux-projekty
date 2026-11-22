#!/bin/bash
if [ "$EUID" -ne 0 ]; then
	echo "Tylko root moze uruchomic ten program!"
	exit 1
fi

echo ""
echo "AUDYT BEZPIECZENSTWA"
echo "-----"

firewall=$(ufw status | grep -o -w "active")
if [ "$firewall" = "active" ]; then
	echo "[OK] Firewall (ufw) jest wlaczony"
else
	echo "[!!!] Firewall (ufw) jest wylaczony"
fi

rootlogin=$(grep -o -w "^PermitRootLogin no" /etc/ssh/sshd_config)
if [ "$rootlogin" = "PermitRootLogin no" ]; then
	echo "[OK] Logowanie roota przez SSH jest wylaczone"
else
	echo "[!!!] Logowanie roota przez SSH nie jest wylaczone"
fi

fail2ban=$(systemctl is-active fail2ban | grep -o -w "active")
if [ "$fail2ban" = "active" ]; then
	echo "[OK] Fail2ban dziala"
else
	echo "[!!!] Fail2ban nie dziala"
fi

plikisuid=$(find / -type f -perm -4000 2>/dev/null)
if [ -z "$plikisuid" ]; then
	echo "[INFO] Plikow SUID w systemie: $ileplikisuid"
else
	ileplikisuid=$(echo "$plikisuid" | wc -l)
	echo "[INFO] Znaleziono $ileplikisuid plikow SUID"
	while read linia
	do
		echo "	$linia"
	done <<< "$plikisuid"
fi

aktualizacje=$(apt list --upgradable 2>/dev/null | grep -c "upgradable")
if [ "$aktualizacje" -eq 0 ]; then
	echo "[OK] Brak dostepnych aktualizacji"
else
	echo "[!!!] Oczekujacych aktualizacji: $aktualizacje"
fi

logowania=$(journalctl -u ssh --since "24 hours ago" | grep -c -w "Failed")
if [ "$logowania" -eq 0 ]; then
	echo "[OK] Brak nieudanych logowan SSH w ciagu ostatnich 24 godzin"
else
	echo "[!!!] Nieudanych logowan SSH w ciagu ostatnich 24 godzin: $logowania"
fi

echo "-----"
echo "AUDYT ZAKONCZONY"
echo ""
