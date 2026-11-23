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

**Pliki:** [`Analizator logow/`](./Analizator%20logow/)

---

### Monitor integralności plików

Skrypt zapisuje sumy kontrolne wybranych plików i później sprawdza, czy któryś z nich został zmieniony lub usunięty.

**Co robi:**
- tryb `init` liczy sumę SHA-256 każdego pilnowanego pliku i zapisuje ją do pliku wzorca
- tryb `check` porównuje aktualne sumy ze wzorcem
- dla każdego pliku wypisuje `OK`, informację o zmianie albo o usunięciu
- na końcu podaje, ile plików sprawdzono i ile zmian wykryto
- kod wyjścia to `0`, gdy wszystko się zgadza, i `1`, gdy wykryto zmianę lub wystąpił błąd

**Jak uruchomić:**

```bash
chmod +x integralnosc.sh
sudo ./integralnosc.sh init
sudo ./integralnosc.sh check
```

**Ograniczenia:**
- lista pilnowanych plików i ścieżka wzorca są wpisane na stałe na początku skryptu, więc przed użyciem trzeba je dostosować
- brakujący plik w trybie `init` jest tylko zgłaszany ostrzeżeniem, a kod wyjścia i tak wynosi `0`, więc taki plik nie będzie pilnowany
- dodatkowe argumenty są ignorowane (`check init` wykona się jako `check`)
- wzorzec jest zwykłym plikiem, więc root może go podmienić, a skrypt tego nie wykryje
- pliki, które zmieniają się legalnie (np. logi), będą zgłaszane jako zmienione

**Plik:** [`Integralnosc/integralnosc.sh`](./Integralnosc/integralnosc.sh)

---

## O mnie

Każdy skrypt w tym repozytorium napisałem sam w ramach nauki. Przy komendach, których nie pamiętałem, korzystałem z dokumentacji (`man`, `--help`).
