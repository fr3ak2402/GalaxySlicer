import json
import sys
import shutil

# Funktion zur Sortierung der Schlüssel
def sort_keys(json_obj):
    sorted_json = {}
    # Die ausgewählten Schlüssel oben behalten und unverändert kopieren
    for key in ["type", "name", "from", "instantiation", "inherits"]:
        if key in json_obj:
            sorted_json[key] = json_obj[key]

    # Alle anderen Schlüssel alphabetisch sortieren
    for key in sorted(json_obj.keys()):
        if key not in ["type", "name", "from", "instantiation", "inherits"]:
            if isinstance(json_obj[key], dict):
                sorted_json[key] = sort_keys(json_obj[key])
            else:
                sorted_json[key] = json_obj[key]
    return sorted_json

# Überprüfen, ob der Dateiname als Argument übergeben wurde
if len(sys.argv) != 2:
    print("Verwendung: python sort_json.py <Dateiname>")
    sys.exit(1)

# Dateinamen aus dem Argument extrahieren
dateiname = sys.argv[1]

# Sicherungskopie der ursprünglichen Datei erstellen
backup_dateiname = dateiname + ".bak"
shutil.copyfile(dateiname, backup_dateiname)

# JSON aus der Datei lesen
with open(dateiname, 'r') as json_file:
    json_data = json.load(json_file)

# Sortieren Sie die Schlüssel im JSON-Objekt
sorted_json_data = sort_keys(json_data)

# JSON als formatierten String in eine neue Datei schreiben
sortierter_dateiname = dateiname # + ".sorted"
with open(sortierter_dateiname, 'w') as sorted_json_file:
    json.dump(sorted_json_data, sorted_json_file, indent=4)

print(f"Sortierte JSON-Daten wurden in {sortierter_dateiname} gespeichert.")
print(f"Die ursprünglichen Daten wurden in {backup_dateiname} gesichert.")
