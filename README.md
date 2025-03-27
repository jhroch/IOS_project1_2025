# Bootutil – Správa zaváděcích položek v shellu

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Tento projekt je shellový nástroj `bootutil`, vytvořený jako součást úlohy IOS (Operační systémy) na FIT VUT v roce 2025. Autorem projektu je **Your Name**. Implementuje správu zaváděcích položek podle zjednodušené verze **Boot Loader Specification**.

## Zadání
Projekt vznikl v rámci předmětu IOS 2025 na FIT VUT. Cílem bylo vytvořit nástroj pro správu zaváděcích položek v `.conf` souborech, včetně příkazů pro výpis, odstranění, duplikaci a nastavení výchozích položek. Kompletní zadání je k dispozici v [assignment.html](assignment.html).

## Podrobnosti příkazů
- **`list`:** Vypíše položky ve formátu `<title> (<version>, <linux>)`.
  - `-f`: Seřadí podle názvů souborů.
  - `-s`: Seřadí podle `sort-key` (bez klíče podle názvu souboru).
  - `-k <kernel_regex>`: Filtruje podle `linux`.
  - `-t <title_regex>`: Filtruje podle `title`.
- **`remove <title-regex>`:** Odstraní položky podle regulárního výrazu na `title`.
- **`duplicate [<entry_file_path>]`:** Duplikuje položku (výchozí, pokud není zadána).
  - `-k <kernel_path>`: Nastaví cestu k jádru.
  - `-i <initramfs_path>`: Nastaví cestu k initramfs.
  - `-t <new_title>`: Změní název.
  - `-a <cmdline_args>`: Přidá argumenty do `options`.
  - `-r <cmdline_args>`: Odebere argumenty z `options`.
  - `-d <destination>`: Určí cílový soubor.
  - `--make-default`: Nastaví jako výchozí.
- **`show-default`:** Zobrazí výchozí položku (nenulový kód, pokud není).
  - `-f`: Zobrazí jen cestu.
- **`make-default <entry_file_path>`:** Nastaví položku jako výchozí.

Podporuje přepínač `-b <boot_entries_dir>` pro změnu výchozího adresáře (`/boot/loader/entries`).

## Požadavky
- Bash (direktiva `#!/bin/bash`).
- Standardní UNIX nástroje: `grep`, `sed`, `sort`, `cut`, `xargs`.
- Testováno na Linuxu (referenční VM IOS, user: `ios`, heslo: `ios-shell`).

## Instalace
1. Naklonuj repozitář:
   ```bash
   git clone https://github.com/tvoje-uzivatelske-jmeno/bootutil.git
   cd bootutil
   ```
2. Ujisti se, že má skript spustitelná práva:
   ```bash
   chmod +x bootutil
   ```

## Použití
```bash
./bootutil [-b <boot_entries_dir>] <příkaz> [argumenty]
```

### Příklady
- Výpis všech položek:
  ```bash
  ./bootutil list
  ```
- Seřazení podle `sort-key`:
  ```bash
  ./bootutil list -s
  ```
- Odstranění položek s "Fedora" v názvu:
  ```bash
  ./bootutil remove "Fedora"
  ```
- Duplikace výchozí položky s novým titulkem:
  ```bash
  ./bootutil duplicate -t "New Fedora"
  ```
- Zobrazení výchozí položky:
  ```bash
  ./bootutil show-default
  ```

## Implementační detaily
- Skript je napsán v Bash a využívá GNU nástroje (`sed`, `awk` povoleny).
- Manipulace s příkazovým řádkem jádra (`options`) je řešena pomocí `xargs` pro správné parsování.
- Řazení je implementováno příkazem `sort`, filtry používají `grep -E` pro rozšířené regulární výrazy.
- Nejsou vytvářeny dočasné soubory mimo `<boot_entries_dir>`.

## Stav projektu
- Hotové: `list`, `remove`, `show-default`, `make-default`.
- Rozpracované: `duplicate` (parsování přepínačů a manipulace s `options` v procesu).

## Autor
- **Jiří Hroch** – student FIT VUT, autor projektu v rámci předmětu IOS 2025.

## Licence
Projekt je šířen pod [GNU General Public License v3.0](LICENSE). Více informací naleznete v souboru [LICENSE](LICENSE).

## Poznámky
- **Upozornění:** Spuštění jako root může ovlivnit systémový adresář `/boot/loader/entries`. Doporučuje se testovat v bezpečném prostředí (např. vlastní testovací adresář).
- Inspirace: Boot Loader Specification (zjednodušená verze pro účely úlohy IOS 2025).

---
