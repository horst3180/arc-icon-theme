#!/bin/bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

pushd `dirname $0` > /dev/null
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
popd > /dev/null

cd ${DIR}

THEMEDIR=../Arc

mkdir -p $THEMEDIR

for CONTEXT in actions apps categories devices emblems mimetypes places status
do

    mkdir -p $THEMEDIR/$CONTEXT
    mkdir -p $THEMEDIR/$CONTEXT

    cp -r $CONTEXT/symbolic $THEMEDIR/$CONTEXT

    for SIZE in 16 22 24 32 48 64 96 128
    do
        $INKSCAPE -S $CONTEXT.svg | grep -E "_$SIZE" | sed 's/\,.*$//' > index.tmp

        mkdir -p $THEMEDIR/$CONTEXT/$SIZE
        mkdir -p $THEMEDIR/$CONTEXT/$SIZE@2x

        cp -r $CONTEXT/symlinks/* $THEMEDIR/$CONTEXT/$SIZE
        cp -r $CONTEXT/symlinks/* $THEMEDIR/$CONTEXT/$SIZE@2x

        for OBJECT_ID in `cat index.tmp`
        do

            ICON_NAME=$(sed "s/\_$SIZE.*$//" <<< $OBJECT_ID)

            if [ -f $THEMEDIR/$CONTEXT/$SIZE/$ICON_NAME.png ]; then
                echo $THEMEDIR/$CONTEXT/$SIZE/$ICON_NAME.png exists.
            else
                echo
                echo Rendering $THEMEDIR/$CONTEXT/$SIZE/$ICON_NAME.png
                $INKSCAPE --export-id=$OBJECT_ID \
                          --export-id-only \
                          --export-png=$THEMEDIR/$CONTEXT/$SIZE/$ICON_NAME.png $CONTEXT.svg >/dev/null \
                && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i.png 
            fi
            if [ -f $THEMEDIR/$CONTEXT/$SIZE@2x/$ICON_NAME.png ]; then
                echo $THEMEDIR/$CONTEXT/$SIZE@2x/$ICON_NAME.png exists.
            else
                echo
                echo Rendering $THEMEDIR/$CONTEXT/$SIZE@2x/$ICON_NAME.png
                $INKSCAPE --export-id=$OBJECT_ID \
                          --export-dpi=180 \
                          --export-id-only \
                          --export-png=$THEMEDIR/$CONTEXT/$SIZE@2x/$ICON_NAME.png $CONTEXT.svg >/dev/null \
                && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i@2.png 
            fi
        done
    done
done

rm index.tmp
cp index.theme $THEMEDIR/index.theme
rm -rf $THEMEDIR/actions/{32,32@2x,48,48@2x,64,64@2x,96,96@2x,128,128@2x} # derp

# TODO
cp -r animations $THEMEDIR/.
cp -r panel $THEMEDIR/.
