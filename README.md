meta_eiqa: the workspace package for meta-eiqa
===============================================

this folder includes 
  - meta-eiqa - the yocto layer for integrating eIQAuto into yocto build environment
  - guider.sh - the script to guide setup of yocto build environment and integrate of the meta-eiqa into the yocto build environment 
  - scripts/* - te scripts called by guider.sh
    - options.sh - this file provides modifiable options for guider.sh
  - externals/* - to hold external binaries be required but can't directly be fetched by recipes
  - externals.inc - this file is required by `build_<machne-name>/conf/local.conf` to provide bitbake the pathes to external binaries  


to prepare externals/
==============================

  current known items  
  - the eiqa-runtime prebuilt parckage : eIQAuto_S32G_3.5.0_RTM.tar.gz 
  - Firmware binaries for the pfe interface of S32G
  - Firmware binaries for the sja1110 interface
  - GoldVIP binaries required by fsl-image-goldvip.bb

  steps to do manually
  - download neccessary items in above list depending on used build image recipe
  - unpack or directly put into externals folder depending on lines of externals.inc
  - append the following lines to `<build-folder>/conf/local.conf`  
```
    EXTERNALS_DIR = <full-path-to-externals>  
    require <full-path-to-externals.inc>
```

use of guider.sh
======================
```
  source guider.sh
```
  this script guides through steps to setup build environment :  
  - help to seelct the manifest and the target machine, more options can be 
    provided by modifying the scripts/options.sh
  - creating folder `manifest.<manifest-name>` for selected manifest 
  - to do 'repo init ... && repo sync' in the folder `manifest.<manifest-name>`
  - calling the nxp-setup-alb.sh to create build environment in `build_<machine>`
  - adding meta-eiqa into layers of the build environment in `build_<machine>`

