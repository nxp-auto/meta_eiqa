#inherit kernel-yocto

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# Add the required kernel configs for EIQA
DELTA_KERNEL_DEFCONFIG_append = " \
    modify.cfg \
"
SRC_URI_append = "file://modify.cfg"
