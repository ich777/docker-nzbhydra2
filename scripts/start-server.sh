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
        LAT_V=$CUR_V
    fi
fi

if [ -f ${DATA_DIR}/NZBHydra2-v$LAT_V.zip ]; then
    rm -rf ${DATA_DIR}/NZBHydra2-v$LAT_V.zip
fi

# Set correct download filename
TARGET_V="5.0.9"
COMPARE="$LAT_V
$TARGET_V"
if [ "$TARGET_V" != "$(echo "$COMPARE" | sort -V | tail -1)" ]; then
    DL_NAME="amd64-linux"
else
    DL_NAME="linux"
fi

echo "---Version Check---"
if [ -z "$CUR_V" ]; then
    echo "---NZBHydra2 not found, downloading and installing v$LAT_V...---"
    if [ ! -d ${DATA_DIR}/NZBHydra2 ]; then
        mkdir -p ${DATA_DIR}/NZBHydra2
    fi
    cd ${DATA_DIR}
    if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/NZBHydra2-v$LAT_V.zip "https://github.com/theotherp/nzbhydra2/releases/download/v${LAT_V}/nzbhydra2-${LAT_V}-${DL_NAME}.zip" ; then
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
    rm -rf ${DATA_DIR}/NZBHydra2
    rm -rf ${DATA_DIR}/installed-*
    cd ${DATA_DIR}
    if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/NZBHydra2-v$LAT_V.zip "https://github.com/theotherp/nzbhydra2/releases/download/v${LAT_V}/nzbhydra2-${LAT_V}-${DL_NAME}.zip" ; then
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
if [ "${LAT_V%%.*}" -ge "5" ]; then
    if [ ! -x "${DATA_DIR}/NZBHydra2/core" ]; then
        chmod +x ${DATA_DIR}/NZBHydra2/core
    fi
fi
if [ ! -d ${DATA_DIR}/.config ]; then
    mkdir -p ${DATA_DIR}/.config
fi

echo "---Starting NZBHydra2---"
cd ${DATA_DIR}/NZBHydra2
${DATA_DIR}/NZBHydra2/nzbhydra2 --datafolder ${DATA_DIR}/.config --nobrowser --nocolors ${START_PARAMS}