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
	echo "[OK] Firewall"
else
	echo "[!!!] Brak Firewall"
fi

rootlogin=$(grep -o -w "^PermitRootLogin no" /etc/ssh/sshd_config)
if [ "$rootlogin" = "PermitRootLogin no" ]; then
	echo "[OK] Root Login"
else
	echo "[!!!] Brak Root Login ustawionego na 'no'"
fi

fail2ban=$(systemctl is-active fail2ban | grep -o -w "active")
if [ "$fail2ban" = "active" ]; then
	echo "[OK] Fail2ban"
else
	echo "[!!!] Brak Fail2ban"
fi

plikisuid=$(find / -type f -perm -4000 2>/dev/null)
if [ -z "$plikisuid" ]; then
	echo "[INFO] Brak plikow SUID"
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
	echo "[!!!] $aktualizacje dostepne aktualizacje"
fi

logowania=$(journalctl -u ssh --since "24 hours ago" | grep -c -w "Failed")
if [ "$logowania" -eq 0 ]; then
	echo "[OK] Brak niepoprawnych logowan w ciagu ostatnich 24 godzin"
else
	echo "[!!!] $logowania nieudanych logowan w ciagu ostatnich 24 godzin"
fi

echo "-----"
echo "AUDYT ZAKONCZONY"
echo ""
