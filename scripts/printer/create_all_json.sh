#!/bin/bash

# Funktion, die das angegebene Skript für jedes gefundene Verzeichnis ausführt
execute_script_for_directories() {
    local root_directory="$1"
    local script_to_execute="$2"

    # Durchlaufe alle Unterverzeichnisse im angegebenen Root-Verzeichnis
    for dir in "$root_directory"/*; do
        if [ -d "$dir" ]; then
            local subdir=$(basename "$dir")
            echo "Ausführen des Skripts '$script_to_execute' für das Verzeichnis: $subdir"
            # Führe das angegebene Skript für das gefundene Verzeichnis aus und übergebe das Verzeichnis als Parameter
            "$script_to_execute" "$subdir"
        fi
    done
}

# Hauptskript

# Überprüfe, ob ein Argument (das Root-Verzeichnis) übergeben wurde
if [ $# -eq 0 ]; then
    # Wenn kein Argument übergeben wurde, setze das aktuelle Verzeichnis als Root-Verzeichnis
    root_directory="."
else
    root_directory="$1"
fi

# Überprüfe, ob das angegebene Root-Verzeichnis existiert
if [ ! -d "$root_directory" ]; then
    echo "Das angegebene Root-Verzeichnis existiert nicht: $root_directory"
    exit 1
fi

# Hier das Skript angeben, das für jedes gefundene Verzeichnis ausgeführt werden soll
# Ersetzen Sie 'skript_ausfuehren.sh' durch den tatsächlichen Namen des Skripts, das Sie ausführen möchten.
# Beachten Sie, dass sich das Skript im gleichen Verzeichnis befinden muss wie dieses Skript oder Sie müssen den vollständigen Pfad angeben.
skript_ausfuehren="./create_json.sh"

# Führe die Funktion aus, um das angegebene Skript für jedes gefundene Verzeichnis auszuführen
execute_script_for_directories "$root_directory" "$skript_ausfuehren"
