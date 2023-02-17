#!/bin/sh
MANIFESTS=(
'
MANIFEST_URL="https://source.codeaurora.org/external/autobsps32/auto_yocto_bsp/"; 
MANIFEST_REV="release/bsp34.0"
MANIFEST_DIR="manifest.auto_yocto_bsp"
MANIFEST_XML="default.xml"
IMAGES=(fsl-image-auto)
'
'
MANIFEST_URL="https://source.codeaurora.org/external/autobsps32/goldvip/gvip-manifests/";
MANIFEST_REV="refs/tags/goldvip-1.5.0"
MANIFEST_DIR="manifest.gvip"
MANIFEST_XML="default.xml"
IMAGES=(fsl-image-auto fsl-image-goldvip)
'
)

MACHINES=(32g233aevb s32g233aevbubuntu s32g254aevb s32g254aevbubuntu s32g274abluebox3 s32g274abluebox3ubuntu s32g274a_emu s32g274aevb s32g274aevbubuntu s32g274ardb2 s32g274ardb2ubuntu s32g274sim s32g378aevb3 s32g378aevb3ubuntu s32g378aevb s32g378aevbubuntu s32g379aevb3 s32g379aevb3ubuntu s32g379aevb s32g379aevbubuntu s32g398aevb3 s32g398aevb3ubuntu s32g398aevb s32g398aevbubuntu s32g399aevb3 s32g399aevb3ubuntu s32g399aevb s32g399aevbubuntu s32g399ardb3 s32g399ardb3ubuntu s32r45evb s32r45evbubuntu s32r45sim goldvip-s32g-domu)

IMAGE_BB=fsl-image-auto

