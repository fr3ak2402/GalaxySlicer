import os
import json

def find_and_keep_last_duplicate_keys(directory):
    # Schritt 1: Durchsuche das Verzeichnis nach JSON-Dateien
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".json"):
                file_path = os.path.join(root, file)
                print(f"Verarbeite {file_path}")

                # Öffne die JSON-Datei und lade sie in ein Dictionary
                with open(file_path, 'r') as f:
                    data = json.load(f)

                # Ein neues leeres Dictionary erstellen
                unique_data = {}

                # Schritt 2: JSON-Datei durchgehen und doppelte Schlüssel überschreiben
                for key, value in data.items():
                    unique_data[key] = value  # Überschreibe den Wert, falls der Schlüssel bereits existiert

                # Schritt 3: Das neue Dictionary in die ursprüngliche Datei speichern
                with open(file_path, 'w') as f:
                    json.dump(unique_data, f, indent=4)

if __name__ == "__main__":
    import sys

    if len(sys.argv) != 2:
        print("Verwendung: python script.py <Verzeichnis>")
        sys.exit(1)

    directory_to_search = sys.argv[1]
    find_and_keep_last_duplicate_keys(directory_to_search)
