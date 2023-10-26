echo $PWD
          pot_file="./localization/i18n/GalaxySlicer.pot"
          for dir in ./localization/i18n/*/
          do
              dir=${dir%*/}      # remove the trailing "/"
              lang=${dir##*/}    # extract the language identifier
              #dir anzeigen
                echo $dir
                #lang anzeigen
                #echo $lang
                # Check if the language identifier is a valid language code
              if [ -f "$dir/GalaxySlicer_${lang}.po" ]; then
                  mkdir -p ./resources/i18n/${lang}/
                  msgfmt --check-format -o ./resources/i18n/${lang}/GalaxySlicer.mo $dir/GalaxySlicer_${lang}.po
                  # Check the exit status of the msgfmt command
                  if [ $? -ne 0 ]; then
                      echo "Error encountered with msgfmt command for language ${lang}."
                      exit 1  # Exit the script with an error status
                  fi
              fi
          done