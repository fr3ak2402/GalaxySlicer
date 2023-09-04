import os
import re

# Das Verzeichnis, in dem Sie nach CPP-Dateien suchen möchten
verzeichnis = '/Users/hliebscher/github/GalaxySlicer/'

# Die Datei, in der Sie die Tabelle speichern möchten
ausgabedatei = 'gefundene_wxcolor_werte.txt'

# Das reguläre Ausdrucksmuster, um alles innerhalb der Klammer von 'wxColour' zu erfassen
suchmuster = r'wxColour\(([^)]+)\)'

# Öffnen Sie die Ausgabedatei im Schreibmodus
with open(ausgabedatei, 'w') as ausgabe:
    ausgabe.write("Datei\tZeile\tWert\tHEX-Wert\n")  # Header für die Tabelle
    # Durchsuchen Sie das Verzeichnis und seine Unterverzeichnisse nach CPP-Dateien
    for ordnerpfad, _, dateien in os.walk(verzeichnis):
        for datei in dateien:
            if datei.endswith('pp'):
                dateipfad = os.path.join(ordnerpfad, datei)
                # Öffnen Sie jede CPP-Datei zum Lesen
                with open(dateipfad, 'r') as dateiobjekt:
                    zeilennummer = 0
                    # Durchsuchen Sie die Zeilen der Datei
                    for zeile in dateiobjekt:
                        zeilennummer += 1
                        # Suchen Sie nach dem regulären Ausdruck in der Zeile
                        treffer = re.search(suchmuster, zeile)
                        if treffer:
                            # Extrahieren Sie den Wert innerhalb der Klammer und entfernen Sie Leerzeichen
                            wert = treffer.group(1).replace(" ", "")
                            # Überprüfen Sie, ob der Wert aus drei Zahlen besteht
                            zahlen = wert.split(',')
                            if len(zahlen) == 3:
                                try:
                                    r, g, b = map(int, zahlen)
                                    # Berechnen Sie den HEX-Wert
                                    hex_wert = "#{:02X}{:02X}{:02X}".format(r, g, b)
                                except ValueError:
                                    hex_wert = "Ungültig"
                            else:
                                hex_wert = "Ungültig"
                            # Schreiben Sie den Dateinamen, die Zeilennummer, den Wert und den HEX-Wert in die Tabelle
                            ausgabe.write(f'{dateipfad}\t{zeilennummer}\t{wert}\t{hex_wert}\n')
