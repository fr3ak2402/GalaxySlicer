#!/bin/bash

# Funktion zum Durchsuchen eines bestimmten Unterverzeichnisses und Erstellen der JSON-Struktur
explore_filament() {
    local dir="$1"
    local subdir="$2"
    local indent="$3"
    local fdm_files_common=$(find "$dir" -maxdepth 1 -type f -name "fdm_filament_common.json" | sort)
    local fdm_files=$(find "$dir" -maxdepth 1 -type f -name "fdm*.json"  ! -name "fdm_filament_common.json"| sort)
    local other_files=$(find "$dir" -maxdepth 1 -type f -name "*.json" ! -name "fdm*.json" | sort -r)
    local json_string=""
    local leer="      " 

    IFS=$'\n'

    for file in $fdm_files_common; do
         set_json_string
    done
    
    for file in $fdm_files; do
        set_json_string
    done
   
    for file in $other_files; do
         set_json_string
    done

    unset IFS

    if [ -n "$json_string" ]; then
        json_string=${json_string%???} # # Die letzten 3 Zeichen entfernen
    fi

    echo "${indent}["
    echo -e "$json_string"
    echo "${indent}]"
    
}

explore_process() {
    local dir="$1"
    local subdir="$2"
    local indent="$3"
    local fdm_files_common=$(find "$dir" -maxdepth 1 -type f -name "fdm_process_common.json" | sort)
    local fdm_files=$(find "$dir" -maxdepth 1 -type f -name "fdm*.json"  ! -name "fdm_process_common.json"| sort)
    local other_files=$(find "$dir" -maxdepth 1 -type f -name "*(*.json" ! -name "fdm*.json" | sort)
    local json_string=""
    local leer="      " 

    IFS=$'\n'

    for file in $fdm_files_common; do
         set_json_string
    done
    
    for file in $fdm_files; do
         set_json_string
    done
   
    for file in $other_files; do
         set_json_string
    done

    unset IFS

    if [ -n "$json_string" ]; then
        json_string=${json_string%???} # # Die letzten 3 Zeichen entfernen
    fi

    echo "${indent}["
    echo -e "$json_string"
    echo "${indent}]"
    
}

explore_machine_model_list() {
    local dir="$1"
    local subdir="$2"
    local indent="$3"
    local files=$(find "$dir" -maxdepth 1 -type f -name "*.json" ! -name "*nozzle)*" ! -name "fdm*" | sort)
    local json_string=""
    local leer="      " 

    IFS=$'\n'

    for file in $files; do
         set_json_string
    
    done
   
    unset IFS

    if [ -n "$json_string" ]; then
        json_string=${json_string%???} # Die letzten 3 Zeichen entfernen
    fi

    echo "${indent}["
    echo -e "$json_string"
    echo "${indent}]"
        
}

explore_machine() {
    local dir="$1"
    local subdir="$2"
    local indent="$3"
    local fdm_files_common=$(find "$dir" -maxdepth 1 -type f -name "fdm_machine_common.json" | sort)
    local fdm_files=$(find "$dir" -maxdepth 1 -type f -name "fdm*.json"  ! -name "fdm_machine_common.json"| sort)
    local other_files=$(find "$dir" -maxdepth 1 -type f -name "*nozzle)*.json" ! -name "fdm*.json" | sort)
    local json_string=""
    local leer="      " 

    IFS=$'\n'

    for file in $fdm_files_common; do
         set_json_string
    done

    for file in $fdm_files; do
         set_json_string
    done
   
    for file in $other_files; do
         set_json_string
    done

    unset IFS

    if [ -n "$json_string" ]; then
        json_string=${json_string%???} #Die letzten 3 Zeichen entfernen
    fi

    echo "${indent}["
    echo -e "$json_string"
    echo "${indent}]"
    
}

set_json_string() {
        local full_filename="$file"
        local filename=$(basename "$file")
        local filename_without_extension="${filename%.*}"
        local directory_path=$(dirname "$file")
        local extension="${filename##*.}"
        local filename=$(basename "$file")
        local name=$(echo "$filename" | cut -d '.' -f 1 | tr -d '[:space:]')
        json_string+="${indent}"
        json_string+="{\n"
        json_string+="$leer\"name\": \"$filename_without_extension\",\n"
        json_string+="$leer\"sub_path\": \"$subdir/$filename\"\n"
        json_string+="  },\n"
}


# Hauptskript zum Erstellen der snapmaker.json-Datei
main() {
    local base_directory="$1"  # Verzeichnisname als erster Eingabeparameter
    #local json_filename="snapmaker_$1_1.json"  # JSON-Dateiname entsprechend der übergebenen Variablen und Nummerierung
    local json_filename="$1.json"  # JSON-Dateiname entsprechend der übergebenen Variablen und Nummerierung
    local counter=1

    #while [ -e "$json_filename" ]; do
    #   ((counter++))
    #   json_filename="snapmaker_$1_$counter.json"
    #done

    if [ ! -d "$base_directory" ]; then
        echo "Das Verzeichnis $base_directory existiert nicht."
        exit 1
    fi

    local json_string="{\n"
    json_string+="\"name\": \"$1\",\n"
    json_string+="\"version\": \"01.00.00.00\",\n"
    json_string+="\"force_update\": \"0\",\n"
    json_string+="\"description\": \"${1} configurations\",\n"
    json_string+="\"machine_model_list\": $(explore_machine_model_list "$base_directory/machine" "machine" "  "),\n"
    json_string+="\"process_list\": $(explore_process "$base_directory/process" "process" "  "),\n"
    json_string+="\"filament_list\": $(explore_filament "$base_directory/filament" "filament" "  "),\n"
    json_string+="\"machine_list\": $(explore_machine "$base_directory/machine" "machine" "  ")\n"
    json_string+="}\n"
    echo -e "$json_string" > "$json_filename"

    echo "Die $json_filename-Datei wurde erfolgreich erstellt!"
}

# Verzeichnisname als Eingabeparameter an das Skript übergeben



main "$1"
