meta_eiqa: the workspace package for meta-eiqa
===============================================

this folder includes 
  - meta-eiqa - the yocto layer for integrating eIQ Auto runtime prebuilt for NXP S32G into yocto build environment
  - guider.sh - the script to guide setup of yocto build environment and integrate of the meta-eiqa into the yocto build environment 
  - scripts/* - scripts called by guider.sh
    - options.sh - this file provides modifiable options for guider.sh
  - externals/* - to hold external binaries be required but can't directly be fetched by recipes
  - externals.inc - this file is required by `build_<machne-name>/conf/local.conf` to provide bitbake the pathes to external binaries  

Dependencies
==============

  URI: https://source.codeaurora.org/external/autobsps32/meta-alb/  
  branch: >= release/bsp33.0

  >note: the dependencies of above list are not listed here

Verified Yocto Manifests
==========================

  - https://source.codeaurora.org/external/autobsps32/auto_yocto_bsp/
  - https://source.codeaurora.org/external/autobsps32/goldvip/gvip-manifests/

to prepare folder externals/
==============================

  current known items  
  - the eiqa-runtime prebuilt parckage : eIQAuto_S32G_3.5.0_RTM.tar.gz 
  - Firmware binaries for the pfe interface of S32G
  - Firmware binaries for the sja1110 interface
  - GoldVIP binaries required by image recipe `fsl-image-goldvip.bb`

  to do manually
  - download neccessary items in above list depending on used build image recipe
  - unpack or directly put into externals/ folder depending on lines of externals.inc

to prepare build environment using guider.sh
=============================================
```
  source guider.sh
```
  this script guides through steps to setup build environment :  
  - help to select the manifest and the target machine from list of options these are revisable in the scripts/options.sh
  - creating folder `manifest.<manifest-name>` for the selected manifest 
  - to do 'repo init ... && repo sync' in the folder `manifest.<manifest-name>`
  - calling the nxp-setup-alb.sh to create build folder `build_<machine>`
  - adding the meta-eiqa folder into layers of the build environment in `build_<machine>`

to prepare build environment manually
=============================================

  - Following README of https://source.codeaurora.org/external/autobsps32/auto_yocto_bsp/ to
  setup the local yocto environment and create build directory for a target board of NXP S32G
  with following command line   
```
    nxp-setup-alb.sh -m <machine> -e <path to meta-eiqa>
```
  - append the following lines to `<build-folder>/conf/local.conf`  
```
    EXTERNALS_DIR = <full-path-to-externals>
    require <full-path-to-externals.inc>
```
  - add meta-eiqa/ folder to layers of build environment by
```
    bitbake-layers add-layer <path to meta-eiqa>
```  
