#!/bin/bash

# Vychozi adresar
BOOT_DIR="/root/IOS_project1_2025/test"

# -b presmerovani adresare
while [ $# -gt 0 ]; do
    case "$1" in
        -b)
            BOOT_DIR="$2"
            shift 2
            ;;
        *)
            break
            ;;
    esac
done

# kontrola jestli adresar existuje
if [ ! -d "$BOOT_DIR" ]; then
    echo "Chyba: Adresář $BOOT_DIR neexistuje!" >&2
    exit 1
fi

# Ziskani prikazu
COMMAND="$1"
shift

# Rozdeleni podle prikazu
case "$COMMAND" in
    list)
                # Kontrola, jestli jsou v adresáři .conf soubory
        conf_found=0
        for file in "$BOOT_DIR"/*.conf; do
            if [ -f "$file" ]; then
                conf_found=1
                break
            fi
        done

        if [ $conf_found -eq 0 ]; then
            echo "Chyba: Žádné .conf soubory v $BOOT_DIR!" >&2
            exit 1
        fi

        # Spusteni prikazu list bez prepinace
        if [ ! $# -gt 0 ]; then
                for file in "$BOOT_DIR"/*.conf; do
                        title=$(grep "^title " "$file" | tail -n1 |  cut -d " " -f 2-)
                        version=$(grep "^version " "$file" | tail -n1 | cut -d " " -f 2-)
                        linux=$(grep "^linux " "$file" |tail -n1 |  cut -d " " -f 2-)
                        echo "$title ($version, $linux)"
                done
                exit 0
        fi

        # Prepinace prikazu list
        case "$1" in
                -f)
                for file in $(ls -1 "$BOOT_DIR"/*.conf | sort); do
                        title=$(grep "^title " "$file" | tail -n1 | cut -d " " -f 2-)
                        version=$(grep "^version " "$file" | tail -n1 | cut -d " " -f 2-)
                        linux=$(grep "^linux " "$file" | tail -n1 | cut -d " " -f 2-)
                        echo "$title ($version, $linux)"
                done
                ;;
                -s)
                        temp_file="$BOOT_DIR/temp.txt"
                        for file in "$BOOT_DIR"/*.conf; do
                                sort_key=$(grep "^sort-key " "$file" | tail -n1 | cut -d " " -f 2-)
                                title=$(grep "^title " "$file" | tail -n1 | cut -d " " -f 2-)
                                version=$(grep "^version " "$file" | tail -n1 | cut -d " " -f 2-)
                                linux=$(grep "^linux " "$file" | tail -n1 | cut -d " " -f 2-)
                                # Pokud sort_key neexistuje, vytvor hodne vysoky -> aby byl za kazdou cenu posledni (~)
                                if [ -z "$sort_key" ]; then
                                        sort_key="~$(basename "$file")"
                                else
                                        sort_key="$sort_key"$(basename "$file")
                                fi
                                # Uložíme do formátu: sort_key|celý_výpis
                                echo "$sort_key|$title ($version, $linux)" >> "$temp_file"
                        done
                        # Seřadíme a vypíšeme jen výpisní část
                        sort "$temp_file" | cut -d'|' -f2-
                        # Smažeme dočasný soubor
                        rm -f "$temp_file"
                ;;
                -k)
                        KERNEL_REGEX="$2"
                        for file in "$BOOT_DIR"/*.conf; do
                                title=$(grep "^title " "$file" | tail -n1 | cut -d " " -f 2-)
                                version=$(grep "^version " "$file" | tail -n1 | cut -d " " -f 2-)
                                linux=$(grep "^linux " "$file" | tail -n1 | cut -d " " -f 2-)
                                if [ "$linux" == "$KERNEL_REGEX" ]; then
                                        echo "$title ($version, $linux)"
                                fi
                        done
                        ;;
                -t)
                        TITLE_REGEX="$2"
                        for file in "$BOOT_DIR"/*.conf; do
                                title=$(grep "^title " "$file" | tail -n1 | cut -d " " -f 2-)
                                version=$(grep "^version " "$file" | tail -n1 | cut -d " " -f 2-)
                                linux=$(grep "^linux " "$file" | tail -n1 | cut -d " " -f 2-)
                                if [ "$title" == "$TITLE_REGEX" ]; then
                                        echo "$title ($version, $linux)"
                                fi
                        done
                        ;;
                *)
                        echo "Neznamy prepinac '$1'" >&2
        esac
    ;;

    remove)
        TITLE_REGEX="$1"
        for file in "$BOOT_DIR"/*.conf; do
                title=$(grep "^title " "$file" | tail -n1 | cut -d " " -f 2-)
                if [ "$title" = "$TITLE_REGEX" ]; then
                        rm -f "$file"
                fi
        done


        ;;

    show-default)
        foundFile=0
        for file in "$BOOT_DIR"/*.conf; do
                default=$(grep "^vutfit_default " "$file" | tail -n1 | cut -d " " -f 2-)
                if [ "$default" = "y" ]; then
                        if [ "$1" != "-f" ]; then
                                cat "$file"
                                echo    # Vlozi \n 
                                exit 0
                        else
                                echo "$file"
                                exit 0
                        fi
                fi
        done
        exit 1 # Pokud se nenajde zadny vychozi soubor
        ;;
    *)
        echo "Neznámý příkaz: $COMMAND" >&2
        exit 1
        ;;
esac
