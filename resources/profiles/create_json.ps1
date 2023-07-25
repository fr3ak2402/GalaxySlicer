function Set-JsonString {
    param (
        [string]$file,
        [string]$subdir,
        [string]$indent
    )

    $full_filename = $file
    $filename = [System.IO.Path]::GetFileName($file)
    $filename_without_extension = [System.IO.Path]::GetFileNameWithoutExtension($file)
    $directory_path = [System.IO.Path]::GetDirectoryName($file)
    $extension = [System.IO.Path]::GetExtension($file)
    $name = $filename_without_extension.Trim()
    $json_string += "${indent}{`n"
    $json_string += "$leer`"name`": `"$filename_without_extension`",`n"
    $json_string += "$leer`"sub_path`": `"$subdir\$filename`"`n"
    $json_string += "},`n"
}

function Explore-Filament {
    param (
        [string]$dir,
        [string]$subdir,
        [string]$indent
    )

    $fdm_files_common = Get-ChildItem -Path $dir -Filter "fdm_filament_common.json" -File | Sort-Object
    $fdm_files = Get-ChildItem -Path $dir -Filter "fdm*.json" -File | Where-Object { $_.Name -ne "fdm_filament_common.json" } | Sort-Object
    $other_files = Get-ChildItem -Path $dir -Filter "*.json" | Where-Object { $_.Name -notmatch "fdm*.json" } | Sort-Object
    $json_string = ""
    $leer = "      "

    foreach ($file in $fdm_files_common) {
        Set-JsonString -file $file.FullName -subdir $subdir -indent $indent
    }

    foreach ($file in $fdm_files) {
        Set-JsonString -file $file.FullName -subdir $subdir -indent $indent
    }

    foreach ($file in $other_files) {
        Set-JsonString -file $file.FullName -subdir $subdir -indent $indent
    }

    if ($json_string.Length -gt 0) {
        $json_string = $json_string.TrimEnd(",`n")
    }

    Write-Output "${indent}[`n$json_string`n${indent}]"
}

function Explore-Process {
    param (
        [string]$dir,
        [string]$subdir,
        [string]$indent
    )

    $fdm_files_common = Get-ChildItem -Path $dir -Filter "fdm_process_common.json" -File | Sort-Object
    $fdm_files = Get-ChildItem -Path $dir -Filter "fdm*.json" -File | Where-Object { $_.Name -ne "fdm_process_common.json" } | Sort-Object
    $other_files = Get-ChildItem -Path $dir -Filter "*(*.json" | Where-Object { $_.Name -notmatch "fdm*.json" } | Sort-Object
    $json_string = ""
    $leer = "      "

    foreach ($file in $fdm_files_common) {
        Set-JsonString -file $file.FullName -subdir $subdir -indent $indent
    }

    foreach ($file in $fdm_files) {
        Set-JsonString -file $file.FullName -subdir $subdir -indent $indent
    }

    foreach ($file in $other_files) {
        Set-JsonString -file $file.FullName -subdir $subdir -indent $indent
    }

    if ($json_string.Length -gt 0) {
        $json_string = $json_string.TrimEnd(",`n")
    }

    Write-Output "${indent}[`n$json_string`n${indent}]"
}

function Explore-MachineModelList {
    param (
        [string]$dir,
        [string]$subdir,
        [string]$indent
    )

    $files = Get-ChildItem -Path $dir -Filter "*.json" | Where-Object { $_.Name -notmatch "*(*" -and $_.Name -notmatch "fdm*" } | Sort-Object
    $json_string = ""
    $leer = "      "

    foreach ($file in $files) {
        Set-JsonString -file $file.FullName -subdir $subdir -indent $indent
    }

    if ($json_string.Length -gt 0) {
        $json_string = $json_string.TrimEnd(",`n")
    }

    Write-Output "${indent}[`n$json_string`n${indent}]"
}

function Explore-Machine {
    param (
        [string]$dir,
        [string]$subdir,
        [string]$indent
    )

    $fdm_files_common = Get-ChildItem -Path $dir -Filter "fdm_machine_common.json" -File | Sort-Object
    $fdm_files = Get-ChildItem -Path $dir -Filter "fdm*.json" -File | Where-Object { $_.Name -ne "fdm_machine_common.json" } | Sort-Object
    $other_files = Get-ChildItem -Path $dir -Filter "*(*.json" | Where-Object { $_.Name -notmatch "fdm*.json" } | Sort-Object
    $json_string = ""
    $leer = "      "

    foreach ($file in $fdm_files_common) {
        Set-JsonString -file $file.FullName -subdir $subdir -indent $indent
    }

    foreach ($file in $fdm_files) {
        Set-JsonString -file $file.FullName -subdir $subdir -indent $indent
    }

    foreach ($file in $other_files) {
        Set-JsonString -file $file.FullName -subdir $subdir -indent $indent
    }

    if ($json_string.Length -gt 0) {
        $json_string = $json_string.TrimEnd(",`n")
    }

    Write-Output "${indent}[`n$json_string`n${indent}]"
}

function Main {
    param (
        [string]$base_directory
    )

    $json_filename = "$base_directory.json"
    $counter = 1

    if (-Not (Test-Path -Path $base_directory -PathType Container)) {
        Write-Output "Das Verzeichnis $base_directory existiert nicht."
        Exit 1
    }

    $json_string = "{`n"
    $json_string += "`"name`": `"$base_directory`",`n"
    $json_string += "`"version`": `"01.00.00.00`",`n"
    $json_string += "`"force_update`": `"0`",`n"
    $json_string += "`"description`": `"$base_directory configurations`",`n"
    $json_string += "`"machine_model_list`: $(Explore-MachineModelList "$base_directory/machine" "machine" "  "),`n"
    $json_string += "`"process_list`: $(Explore-Process "$base_directory/process" "process" "  "),`n"
    $json_string += "`"filament_list`: $(Explore-Filament "$base_directory/filament" "filament" "  "),`n"
    $json_string += "`"machine_list`: $(Explore-Machine "$base_directory/machine" "machine" "  ")`n"
    $json_string += "}`n"
    
    $json_string | Out-File -FilePath $json_filename -Encoding UTF8

    Write-Output "Die $json_filename-Datei wurde erfolgreich erstellt!"
}

# Verzeichnisname als Eingabeparameter an das Skript übergeben
Main $args[0]