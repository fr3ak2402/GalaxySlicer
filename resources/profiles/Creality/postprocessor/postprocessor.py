import sys
import re
import os

def update_signature_and_replace(source_file):
    # Check if the source file exists
    if not os.path.isfile(source_file):
        print(f"The file '{source_file}' does not exist.")
        sys.exit(1)
        
    # Read the G-code file into memory
    with open(source_file, "r") as f:
        content = f.read()
    
    # Extract the printer model information from the content
    printer_model_line = re.search(r';printer_model\s*=\s*(.*)', content)
    printer_model = printer_model_line.group(1).strip()
    
    # Check if the printer model is either "Creality K1" or "Creality K1 Max"
    if printer_model == "Creality K1" or printer_model == "Creality K1 Max":
    
        # Replace '; thumbnail begin' and '; thumbnail end' with '; png begin' and '; png end'
        content = content.replace('; thumbnail begin', '; png begin').replace('; thumbnail end', '; png end')
    
        # Store lines with '; thumbnail begin'
        thumbnail_lines = re.findall(r'; png begin(.+?);', content, re.DOTALL)

        # Edit the stored thumbnail lines by replacing 'x' with '*'
        edited_thumbnail_lines = [line.replace('x', '*') for line in thumbnail_lines]
    
        # Replace the original thumbnail lines with the edited lines
        for i in range(len(thumbnail_lines)):
            content = content.replace(thumbnail_lines[i], edited_thumbnail_lines[i])

        # Update M106 commands: Replace M106 P3 with M106 P1 (commented out as it's not currently used)
        # content = re.sub(r'M106 P3', r'M106 P1', content)

    # Write the updated content back to the same file
    with open(source_file, "w") as of:
        of.write(content)
        
    print('Replacements successfully performed.')

if __name__ == "__main__":
    # Check for the correct number of command-line arguments
    if len(sys.argv) != 2:
        print("Usage: python script.py <path_to_Gcode_file>")
        sys.exit(1)

    # Get the source file path from the command-line arguments and call the update function
    source_file = sys.argv[1]
    update_signature_and_replace(source_file)

