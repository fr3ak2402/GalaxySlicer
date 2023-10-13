import json
import os
import argparse

def find_and_append_inherited_files(start_json_file, input_dir, output_file, processed_files=set()):
    try:
        with open(start_json_file, 'r') as start_file:
            start_data = json.load(start_file)
            inherits_value = start_data.get("inherits")
            if not inherits_value:
                print('Die JSON-Datei enthält kein "inherits" Feld.')
                return
        ## Wenn die Start-JSON-Datei noch nicht verarbeitet wurde, wird sie zur Ausgabedatei hinzugefügt    
        if start_json_file not in processed_files:
            ## Ausgabe der Start-JSON-Datei
            with open(start_json_file, 'r') as start_file:
                data = json.load(start_file)
                with open(output_file, 'a') as output:
                    ## Wenn die Ausgabedatei nicht leer ist, muss ein Komma vor dem neuen JSON-Objekt eingefügt werden
                    sorted_data = {key: data[key] for key in sorted(data.keys())}
                    
                    # In der "sorted_data" Zeile, um die gewünschte Reihenfolge der Schlüssel zu erreichen
                    sorted_data = {}

                    # Hinzufügen von "name" zuerst, falls es existiert
                    if "name" in data:
                        sorted_data["name"] = data["name"]
                    if "version" in data:
                        sorted_data["version"] = data["version"]
                    if "from" in data:
                        sorted_data["from"] = data["from"]
                    if "type" in data:  
                        sorted_data["type"] = data["type"]
                    if "inherits" in data:
                        sorted_data["inherits"] = data["inherits"]
                    if "instantiation" in data:
                        sorted_data["instantiation"] = data["instantiation"]
                        

                    # Hinzufügen der übrigen Schlüssel in aufsteigender Reihenfolge
                    for key in sorted(data.keys()):
                        if key not in ["name", "version", "inherits", "instantiation", "from", "type"]:
                            sorted_data[key] = data[key]


                    
                    json.dump(sorted_data, output, indent=4)
                    output.write('\n')
                    print(f'Inhalt von {start_json_file} zur Ausgabedatei hinzugefügt.')
                ## Hinzufügen der Start-JSON-Datei zur Menge der bereits verarbeiteten Dateien
                processed_files.add(start_json_file)

            ## Rekursiver Aufruf
            for root, dirs, files in os.walk(input_dir):
                for filename in files:
                    if filename.endswith(".json") and os.path.splitext(filename)[0] == inherits_value:
                        file_path = os.path.join(root, filename)
                        find_and_append_inherited_files(file_path, input_dir, output_file, processed_files)
                        
                        
                        

    except FileNotFoundError:
        print('Die Start-JSON-Datei oder das angegebene Verzeichnis wurde nicht gefunden.')
    except json.JSONDecodeError as e:
        print(f'Fehler beim Lesen der JSON-Datei: {e}')
    except Exception as e:
        print(f'Ein Fehler ist aufgetreten: {e}')

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("start_json_file", help="Start-JSON-Datei, aus der der Wert hinter 'inherits' gelesen wird")
    parser.add_argument("input_dir", help="Verzeichnis, in dem nach JSON-Dateien gesucht werden soll")
    parser.add_argument("output_file", help="Ausgabedatei, in die die JSON-Daten geschrieben werden")
    args = parser.parse_args()

    with open(args.output_file, 'w') as output:
        #output.write('[')  # Öffnen der Ausgabedatei als JSON-Array
        find_and_append_inherited_files(args.start_json_file, args.input_dir, args.output_file)
        output.write('{')  # Schließen des JSON-Arrays
