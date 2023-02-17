#!/bin/bash

is_sourced() { [ "$0" = "$BASH_SOURCE" ] && return 1 || return 0; }
if ! is_sourced; then echo "this script need run by source"; exit 0; fi

META_EIQA_TOP=$(realpath $(dirname $BASH_SOURCE))
META_EIQA_DIR=$META_EIQA_TOP/meta-eiqa
EXTERNALS_DIR=$META_EIQA_TOP/externals; [ -d $EXTERNALS_DIR ] || mkdir -p $EXTERNALS_DIR
EXTERNALS_INC_PATH=$META_EIQA_TOP/externals.inc

DOWNLOADS_DIR=$META_EIQA_TOP/downloads; [ -d $DOWNLOADS_DIR ] || mkdir -p $DOWNLOADS_DIR

. $META_EIQA_TOP/scripts/common.sh
. $META_EIQA_TOP/scripts/options.sh
[ x$1 = xtrue ] && PAUSE=pause

EIQA_RUNTIME_PREBUILT_TAR="eIQAuto_S32G_3.5.0_RTM.tar.gz"
EIQA_RUNTIME_PREBUILT_TAR_PATH=$EXTERNALS_DIR/$EIQA_RUNTIME_PREBUILT_TAR

REPO=~/bin/repo

main() {

printf "\n\n# check exist of $EIQA_RUNTIME_PREBUILT_TAR_PATH\n"; 
if [ ! -f $EIQA_RUNTIME_PREBUILT_TAR_PATH ]; then
    echo "need to download $EIQA_RUNTIME_PREBUILT_TAR to $EIQA_RUNTIME_PREBUILT_TAR_PATH"
    return 1
fi

printf "\n\n# check repo\n"
echo "check repo existance..."; 
if [ ! -f $REPO ]; then
    echo "download repo..."
    mkdir ~/bin
    REPO_URL="http://commondatastorage.googleapis.com/git-repo-downloads/repo"
    if ! curl $REPO_URL --output $REPO; then echo "fail to download $REPO_URL"; return; fi
    chmod a+x $REPO
fi

printf "\n\n# check git config\n"
git config --global color.ui true
if ! git config --global --get user.name; then echo "git config --global user.name ?"; return; fi
if ! git config --global --get user.email; then echo "git config --global user.email ?"; return; fi 

printf "\n\n# select manifest : \n"
for i in ${!MANIFESTS[@]}; do
    eval "${MANIFESTS[i]}"; echo "$((i + 1)) - $MANIFEST_URL - $MANIFEST_REV"
done
ask_uint "Seelct manifest from " vManifest 1 ${#MANIFESTS[@]}
eval "${MANIFESTS[$vManifest - 1]}"
printf "\nMANIFEST_URL=$MANIFEST_URL\nMANIFEST_REV=$MANIFEST_REV\n"

printf "\n\n# check manifest existance\n"
MANIFEST_PATH=$META_EIQA_TOP/$MANIFEST_DIR
if [ -d $MANIFEST_PATH ]; then
    echo "the folder $MANIFEST_PATH already exist\n"
    cd $MANIFEST_PATH
else
    if ! mkdir -v -p $MANIFEST_PATH; then echo "Fail to create $MANIFEST_PATH!"; return; fi
    cd $MANIFEST_PATH

    echo "# repo init from $MANIFEST_URL at $MANIFEST_REV..."; $PAUSE
    $REPO init --no-clone-bundle -u $MANIFEST_URL -b $MANIFEST_REV -m $MANIFEST_XML || return 1

    echo "# repo sync..."; $PAUSE
    $REPO sync || return 1
fi

[ -e $DOWNLOADS_DIR ] || ln -s $DOWNLOADS_DIR

printf "\n\n# select machine\n"; $PAUSE
for i in ${!MACHINES[@]}; do echo $((i+1)) - ${MACHINES[i]}; done
ask_uint "Seelct manifest from " vMachine 1 ${#MACHINES[@]}
MACHINE=${MACHINES[vMachine-1]}
MACHINE_DIR="$MANIFEST_PATH/build_$MACHINE"
IMAGE_BB_LIST="build-image-recipe-list.txt"
if [ -d $MACHINE_DIR ]; then
    cd $MACHINE_DIR
    printf "\n$MACHINE_DIR already exist\n\n"
    source SOURCE_THIS
else
    echo "\ncreate build folder $MACHINE_DIR"; $PAUSE
    out=$(EULA=1 source nxp-setup-alb.sh -m $MACHINE -d $DOWNLOADS_DIR) || return 1
    cd $MACHINE_DIR; source SOURCE_THIS
    echo "$out" > $IMAGE_BB_LIST
    
    bitbake-layers add-layer $META_EIQA_DIR
    printf "\n$META_EIQA_DIR\n is added to layers\n"

    LOCAL_CONF_PATH=$MACHINE_DIR/conf/local.conf
    if ! grep EXTERNALS_DIR $LOCAL_CONF_PATH; then
        printf "\nEXTERNALS_DIR = \"$EXTERNALS_DIR\"" >> $LOCAL_CONF_PATH
        printf "\nrequire $EXTERNALS_INC_PATH\n" >> $LOCAL_CONF_PATH
        printf "\n\nexternals be registered to $LOCAL_CONF_PATH\n"
    fi
fi
echo; cat "$IMAGE_BB_LIST"
}

main
