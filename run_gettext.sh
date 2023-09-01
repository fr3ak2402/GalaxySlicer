#!/bin/sh

#  GalaxySlicer gettext
#  Created by SoftFever on 27/5/23.
#
xgettext --keyword=L --keyword=_L --keyword=_u8L --keyword=L_CONTEXT:1,2c --keyword=_L_PLURAL:1,2 --add-comments=TRN --from-code=UTF-8 --no-location --debug --boost -f ./localization/i18n/list.txt -o ./localization/i18n/GalaxySlicer.pot
./build_arm64/src/hints/Release/hintsToPot.app/Contents/MacOS/hintsToPot ./resources ./localization/i18n


echo $PWD
pot_file="./localization/i18n/GalaxySlicer.pot"
for dir in ./localization/i18n/*/
do
    dir=${dir%*/}      # remove the trailing "/"
    lang=${dir##*/}    # extract the language identifier

    if [ -f "$dir/GalaxySlicer_${lang}.po" ]; then
        msgmerge -N -o $dir/GalaxySlicer_${lang}.po $dir/GalaxySlicer_${lang}.po $pot_file
        msgfmt --check-format -o ./resources/i18n/${lang}/GalaxySlicer.mo $dir/GalaxySlicer_${lang}.po
    fi
done
