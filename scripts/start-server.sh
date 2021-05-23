#!/bin/bash
if [ "$NZBHYDRA2_REL" == "latest" ]; then
    LAT_V="$(wget -qO- https://github.com/ich777/versions/raw/master/NZBHydra2 | grep LATEST | cut -d '=' -f2)"
else
    echo "---Version manually set to: v$NZBHYDRA2_REL---"
    LAT_V="$NZBHYDRA2_REL"
fi
CUR_V="$(find ${DATA_DIR} -maxdepth 1 -name "installed-*" | cut -d '-' -f2)"

if [ -z $LAT_V ]; then
    if [ -z $CUR_V ]; then
        echo "---Can't get latest version of NZBHydra2, putting container into sleep mode!---"
        sleep infinity
    else
        echo "---Can't get latest version of NZBHydra2, falling back to v$CUR_V---"
    fi
fi

if [ -f ${DATA_DIR}/NZBHydra2-v$LAT_V.zip ]; then
    rm -rf ${DATA_DIR}/NZBHydra2-v$LAT_V.zip
fi

echo "---Version Check---"
if [ -z "$CUR_V" ]; then
    echo "---NZBHydra2 not found, downloading and installing v$LAT_V...---"
    if [ ! -d ${DATA_DIR}/NZBHydra2 ]; then
        mkdir -p ${DATA_DIR}/NZBHydra2
    fi
    cd ${DATA_DIR}
    if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/NZBHydra2-v$LAT_V.zip "https://github.com/theotherp/nzbhydra2/releases/download/v${LAT_V}/nzbhydra2-${LAT_V}-linux.zip" ; then
        echo "---Successfully downloaded NZBHydra2 v$LAT_V---"
    else
        echo "---Something went wrong, can't download NZBHydra2 v$LAT_V, putting container into sleep mode!---"
        sleep infinity
    fi
    mkdir ${DATA_DIR}/NZBHydra2
    unzip -o ${DATA_DIR}/NZBHydra2-v$LAT_V.zip -d ${DATA_DIR}/NZBHydra2
    chmod +x ${DATA_DIR}/NZBHydra2/nzbhydra2
    touch ${DATA_DIR}/installed-$LAT_V
    rm ${DATA_DIR}/NZBHydra2-v$LAT_V.zip
elif [ "$CUR_V" != "$LAT_V" ]; then
    echo "---Version missmatch, installed v$CUR_V, downloading and installing latest v$LAT_V...---"
    rm -rf ${DATA_DIR}/NZBHydra2 ${DATA_DIR}/installed-$CUR_V
    cd ${DATA_DIR}
    if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/NZBHydra2-v$LAT_V.zip "https://github.com/theotherp/nzbhydra2/releases/download/v${LAT_V}/nzbhydra2-${LAT_V}-linux.zip" ; then
        echo "---Successfully downloaded NZBHydra2 v$LAT_V---"
    else
        echo "---Something went wrong, can't download NZBHydra2 v$LAT_V, putting container into sleep mode!---"
        sleep infinity
    fi
    mkdir ${DATA_DIR}/NZBHydra2
    unzip -o ${DATA_DIR}/NZBHydra2-v$LAT_V.zip -d ${DATA_DIR}/NZBHydra2
    chmod +x ${DATA_DIR}/NZBHydra2/nzbhydra2
    touch ${DATA_DIR}/installed-$LAT_V
    rm ${DATA_DIR}/NZBHydra2-v$LAT_V.zip
elif [ "$CUR_V" == "$LAT_V" ]; then
    echo "---NZBHydra2 v$CUR_V up-to-date---"
fi

echo "---Preparing Server---"
if [ ! -d ${DATA_DIR}/.config ]; then
    mkdir -p ${DATA_DIR}/.config
fi

echo "+-------------------------------------------------------------"
echo "|"
echo "| This container for ARM is deprecated and is no"
echo "| longer actively maintained or further developed!"
echo "|"
echo "|  Container will start in 60 seconds!"
echo "|"
echo "+-------------------------------------------------------------"
sleep 60

echo "---Starting NZBHydra2---"
cd ${DATA_DIR}
/usr/bin/python3 ${DATA_DIR}/NZBHydra2/nzbhydra2wrapperPy3.py --datafolder ${DATA_DIR}/.config --nobrowser --nocolors ${START_PARAMS}