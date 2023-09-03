import os
import re

# Das Verzeichnis, in dem Sie nach CPP-Dateien suchen möchten
verzeichnis = '/Users/hliebscher/github/GalaxySlicer/src'

# Die Datei, in der Sie die Zeilen speichern möchten
ausgabedatei = 'gefundene_wxcolor_zeilen.txt'

# Das reguläre Ausdrucksmuster, um nach den gesuchten Ausdrücken zu suchen
suchmuster = r'wxColour\([^)]+\)'


# Öffnen Sie die Ausgabedatei im Schreibmodus
with open(ausgabedatei, 'w') as ausgabe:
    # Durchsuchen Sie das Verzeichnis und seine Unterverzeichnisse nach CPP-Dateien
    for ordnerpfad, _, dateien in os.walk(verzeichnis):
        for datei in dateien:
            if datei.endswith('.*pp'):
                dateipfad = os.path.join(ordnerpfad, datei)
                # Öffnen Sie jede CPP-Datei zum Lesen
                #log ausgabe welche datei geöffnet wird
                print(f'Öffne Datei: {dateipfad}')
                    
                with open(dateipfad, 'r') as dateiobjekt:
                    zeilennummer = 0
                    # Durchsuchen Sie die Zeilen der Datei
                    for zeile in dateiobjekt:
                        zeilennummer += 1
                        # Suchen Sie nach dem regulären Ausdruck in der Zeile
                        treffer = re.search(suchmuster, zeile)
                        if treffer:
                            # Speichern Sie die Zeile in der Ausgabedatei
                            ausgabe.write(f'In Datei: {dateipfad}, Zeile: {zeilennummer}\n')
