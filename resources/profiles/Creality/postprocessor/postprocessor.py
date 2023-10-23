import sys
import re
import os

def process_gcode(source_file):
    # Check if the source file exists
    if not os.path.isfile(source_file):
        print(f"The file '{source_file}' does not exist.")
        sys.exit(1)
        
    # Read the G-code file into memory
    with open(source_file, "r") as f:
        content = f.read()

    # Extract the printer model from the G-code file
    printer_model = extract_model(content)
        
    # Check if the printer model is either "Creality K1" or "Creality K1 Max"
    if printer_model == "Creality K1" or printer_model == "Creality K1 Max":

        print("Printer model:", printer_model)
    
        # Replace '; thumbnail begin' and '; thumbnail end' with '; png begin' and '; png end'
        content = content.replace('; thumbnail begin', '; png begin').replace('; thumbnail end', '; png end')
    
        # Store lines with '; thumbnail begin'
        thumbnail_lines = re.findall(r'; png begin(.+?);', content, re.DOTALL)

        # Edit the stored thumbnail lines by replacing 'x' with '*'
        edited_thumbnail_lines = [line.replace('x', '*') for line in thumbnail_lines]
    
        # Replace the original thumbnail lines with the edited lines
        for i in range(len(thumbnail_lines)):
            content = content.replace(thumbnail_lines[i], edited_thumbnail_lines[i])

        # Update M106 commands: Replace M106 P3 with M106 P1 -> Chamber fan Gcode
        content = re.sub(r'M106 P3', r'M106 P1', content)

    # Write the updated content back to the same file
    with open(source_file, "w") as of:
        of.write(content)
        
    print('Replacements successfully performed.')

def extract_model(content):
    # Extract the printer model from the G-code file
    printer_model_match = re.search(r'; printer_model = (.+)', content)
    printer_model = None

    if printer_model_match:
        printer_model = printer_model_match.group(1)
    
    return printer_model

if __name__ == "__main__":
    # Check for the correct number of command-line arguments
    if len(sys.argv) != 2:
        print("Usage: python script.py <path_to_Gcode_file>")
        sys.exit(1)
    
    # Get the source file path from the command-line arguments and call the update function
    source_file = sys.argv[1]
    process_gcode(source_file)

