# Linux Projekty

Małe projekty w Bashu, które piszę, ucząc się administracji Linuksem i podstaw cyberbezpieczeństwa.

## Projekty

### Audyt bezpieczeństwa serwera

Skrypt sprawdza podstawowe ustawienia bezpieczeństwa serwera i wypisuje krótki raport. Przy każdej kontroli pokazuje `[OK]` (dobrze) albo `[!!!]` (do poprawy).

**Co sprawdza:**
- czy skrypt działa jako root
- czy firewall (ufw) jest włączony
- czy logowanie roota przez SSH jest wyłączone
- czy działa Fail2ban
- ile jest plików SUID (liczba i lista)
- ile jest oczekujących aktualizacji
- ile było nieudanych logowań przez SSH w ostatnich 24 godzinach

**Jak uruchomić:**

```bash
chmod +x audyt.sh
sudo ./audyt.sh
```

**Ograniczenia:** skrypt tylko pokazuje wyniki, niczego nie naprawia. Działa na Debianie i Ubuntu (używa `apt`). Wymaga roota.

**Plik:** [`Audyt/audyt.sh`](./Audyt/audyt.sh)

---

### Analizator logów

Skrypt szuka w pliku z logami adresów IP, które zbyt często nieudanie próbowały się zalogować, i zapisuje je do pliku `podejrzane.txt`.

**Co robi:**
- bierze nazwę pliku z logami (z argumentu albo pyta o nią)
- liczy linie z nieudanymi logowaniami (`FAILED`)
- pyta o limit prób na jeden adres IP
- adresy z liczbą prób równą limitowi lub większą wypisuje na czerwono i zapisuje do pliku

**Jak uruchomić:**

```bash
chmod +x analizator.sh
./analizator.sh logi.txt
```

**Format logów:** adres IP jest czwartym polem w linii, pola oddzielone spacją.

**Ograniczenia:** skrypt tylko wypisuje podejrzane adresy, nie blokuje ich. Plik `podejrzane.txt` zapisuje się w folderze, z którego uruchomiono skrypt.

**Pliki:** [`analizator-logow/`](./analizator-logow/)

---

## O mnie

Każdy skrypt w tym repozytorium napisałem sam w ramach nauki. Przy komendach, których nie pamiętałem, korzystałem z dokumentacji (`man`, `--help`).
