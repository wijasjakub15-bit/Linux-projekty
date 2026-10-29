# Linux Projekty

Zbiór małych projektów w Bashu, które tworzę ucząc się administracji Linuksem, ze szczególnym naciskiem na podstawy cyberbezpieczeństwa.

## Projekty

### Audyt bezpieczeństwa serwera

Skrypt, który sprawdza podstawowe ustawienia bezpieczeństwa serwera i wypisuje krótki raport. Przy każdej kontroli pokazuje, czy jest dobrze ([OK]), czy coś wymaga poprawy ([!!!]).

**Co sprawdza:**
- czy skrypt jest uruchomiony jako root (jeśli nie, kończy działanie)
- czy firewall (ufw) jest włączony
- czy logowanie na konto root przez SSH jest wyłączone (`PermitRootLogin no`)
- czy działa usługa Fail2ban
- ile jest plików z bitem SUID w systemie (liczba i lista)
- ile jest oczekujących aktualizacji pakietów
- ile było nieudanych logowań przez SSH w ostatnich 24 godzinach

**Jak uruchomić:**

```bash
chmod +x audyt.sh
sudo ./audyt.sh
```

**Użyte technologie:** Bash, warunki `if`, pętla `while read`, zmienne i podstawianie poleceń `$( )`, potoki, `grep`, `wc`, `find`, `systemctl`, `journalctl`, `apt`, `ufw`, przekierowanie błędów `2>/dev/null`

**Testowane na:** Linux Debian/Ubuntu (maszyna wirtualna w VirtualBox)

**Ograniczenia:** skrypt tylko pokazuje wyniki, niczego sam nie zmienia ani nie naprawia. Sprawdzanie aktualizacji działa na systemach z menedżerem `apt`. Wymaga uprawnień roota.

**Plik:** [`Audyt bezpieczenstwa/audyt.sh`](./Audyt%20bezpieczenstwa/audyt.sh)

---
