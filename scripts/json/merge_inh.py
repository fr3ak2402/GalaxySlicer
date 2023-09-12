import os
import json
import sys

# Überprüfe, ob der richtige Anwendungsaufruf vorliegt
if len(sys.argv) != 2:
    print("Verwendung: python program.py <Verzeichnis>")
    sys.exit(1)

# Verzeichnis, in dem nach JSON-Dateien gesucht werden soll
verzeichnis = sys.argv[1]

# Schlüssel, die erhalten bleiben sollen
erhaltene_schluessel = ["type", "name", "setting_id", "system", "from", "filament_id", "instantiation", "inherits"]

# Funktion zum Suchen nach JSON-Dateien, die das Schlüsselpaar "inherits" enthalten
def suche_json_dateien_mit_inherits(verzeichnis):
    gefunden = []

    for verzeichnis_pfad, _, dateien in os.walk(verzeichnis):
        # Überprüfe, ob das Verzeichnis oder Dateiname "BBL" enthält und überspringe es
        if "BBL" in verzeichnis_pfad.split(os.path.sep) or "BBL" in dateien:
            continue

        for dateiname in dateien:
            if dateiname.endswith(".json"):
                datei_pfad = os.path.join(verzeichnis_pfad, dateiname)
                with open(datei_pfad, "r") as datei:
                    daten = json.load(datei)
                    if "inherits" in daten:
                        inherits_wert = daten["inherits"]
                        # Entferne eventuelle Schrägstriche oder umgekehrte Schrägstriche aus dem Dateinamen
                        inherits_dateiname = inherits_wert.replace("/", "").replace("\\", "") + ".json"
                        inherits_datei_pfad = os.path.join(verzeichnis_pfad, inherits_dateiname)
                        gefunden.append((datei_pfad, inherits_datei_pfad))

    return gefunden

# Funktion zum Vergleichen und Entfernen doppelter Werte
def vergleiche_und_entferne_doppelte(basis_datei, inherited_datei):
    with open(basis_datei, "r") as basis:
        basis_daten = json.load(basis)

    with open(inherited_datei, "r") as inherited:
        inherited_daten = json.load(inherited)

    # Entferne doppelte Werte aus der Basisdatei
    for key, value in inherited_daten.items():
        if key not in erhaltene_schluessel and key in basis_daten and basis_daten[key] == value:
            del basis_daten[key]

    # Speichere die aktualisierte Basisdatei ab
    with open(basis_datei, "w") as basis:
        json.dump(basis_daten, basis, indent=4)

# Hauptprogramm
gefundene_paare = suche_json_dateien_mit_inherits(verzeichnis)

if gefundene_paare:
    print("Gefundene Schlüsselpaare (Datei, Inherits-Wert):")
    for basis_datei, inherited_datei in gefundene_paare:
        print(f"Datei 1: {basis_datei}")
        print(f"Datei 2: {inherited_datei}")
        vergleiche_und_entferne_doppelte(basis_datei, inherited_datei)
        print(f"Doppelte Werte in Datei 1 wurden entfernt und gespeichert.")
else:
    print("Keine JSON-Dateien mit Schlüsselpaar 'inherits' gefunden.")
