meta-eiqa : the Yocto layer for eIQ AUTO
==========================================

This yocto layer is used to integrate the eIQ Auto runtime prebuilt for the NXP S32G processors into NXP Auto Linux BSP to build OE Linux image.


Dependencies
==============

  URI: https://source.codeaurora.org/external/autobsps32/meta-alb/  
  branch: >= release/bsp33.0

  >note: the dependencies of above list are not listed here


Content Description
=====================
  
  eiqa-runtime-prebuilt_3.5.0.bb  
  - provide dynamic libraries and demos in generated Linux image
  - provide static libraries, include files and tutorials in the SDK package and RPM modules


Verified Yocto Manifests
==========================

  - https://source.codeaurora.org/external/autobsps32/auto_yocto_bsp/
  - https://source.codeaurora.org/external/autobsps32/goldvip/gvip-manifests/


Usage 
======

  - Following README of https://source.codeaurora.org/external/autobsps32/auto_yocto_bsp/ to
  setup the local yocto environment and create build directory for a target board of NXP S32G
  with following command line   
```
    nxp-setup-alb.sh -m <machine> -e <path to meta-eiqa>
```
  - download eIQAuto_S32G_3.5.0_RTM.tar.gz into a local folder, and create a inc file with the following lines: 
```  
    EIQA_RUNTIME_PREBUILD_TAR_MD5SUM = "<md5sum of eIQAuto_S32G_3.5.0_RTM.tar.gz>"  
    EIQA_RUNTIME_PREBUILD_TAR_SHA1SUM = "<md5sum of eIQAuto_S32G_3.5.0_RTM.tar.gz>"  
    EIQA_RUNTIME_PREBUILT_TAR_PATH = "<full path to eIQAuto_S32G_3.5.0_RTM.tar.gz>"  
```  
  - to append following line to conf/local.conf
```
    require <path-to-this-file>
```

  - to add meta-eiqa layer into yocto layers :  
```
    bitbake-layers add-layer <path to meta-eiqa>
```        
  - to build image :  
``` 
    bitbake fsl-image-auto
```
  - use of build results  
    - flash sdcard with image file at `tmp/deploy/images/<mahine-name>/fsl-image-*.rootfs.sdcard`
    - to install eiqa runtime prebuilt with rpm modules at  
      tmp/deploy/rpm/cortexa53_crypto/eiqa-runtime-prebuilt-*.rpm
 
  