SUMMARY = "To deploy eIQAuto prebuilt into Yocto build image"
DESCRIPTION = "This recipe will install prebuilt of EIQA_RUNTIME into the OE linux"

LICENSE = "LA_OPT_NXP_Software_License"
LIC_FILES_CHKSUM = "file://${EIQAUTO_LICENSE};md5=1fd7428be197def327f364a6f22bfea6"

python do_display_banner() {
    bb.plain("***********************************************");
    bb.plain("*  recipe eiqa_runtime_prebuilt               *");
    bb.plain("***********************************************");
}

addtask display_banner before do_build

S = "${WORKDIR}"

TO_EIQA_ROOT = "${prefix}/local/eiqa"
TO_EIQA_SO = "${libdir_native}"
TO_EIQA_A_= "${TO_EIQA_ROOT}/lib"
TO_EIQA_INC = "${TO_EIQA_ROOT}/include"
TO_EIQA_CMAKE = "${TO_EIQA_ROOT}/cmake"
TO_EIQA_BIN = "${TO_EIQA_ROOT}/bin"
TO_EIQA_DOC = "${TO_EIQA_ROOT}/docs"
TO_EIQA_TUTORIAL = "${TO_EIQA_ROOT}/tutorials"
TO_EIQA_OFFLINE = "${TO_EIQA_ROOT}/offline"

do_install() {

    install -d ${D}${TO_EIQA_SO}
    install -m 0755 ${S}/lib/aarch64/*.so* ${D}${TO_EIQA_SO}

    install -d ${D}${libdir_nativesdk}
    install -m 0755 ${S}/lib/aarch64/*.a ${D}${libdir_nativesdk}

    install -d ${D}${TO_EIQA_CMAKE}
    cp -R ${S}/lib/aarch64/cmake/* ${D}${TO_EIQA_CMAKE}

    install -d ${D}${TO_EIQA_INC}
    cp -R ${S}/include/* ${D}${TO_EIQA_INC}

    install -d ${D}${TO_EIQA_BIN}
    cp -R ${S}/bin/* ${D}${TO_EIQA_BIN}

    install -d ${D}${TO_EIQA_TUTORIAL}
    cp -R ${S}/tutorials/* ${D}${TO_EIQA_TUTORIAL}

    #install -d ${D}${TO_EIQA_DOC}
    #cp -R ${S}/docs/* ${D}${TO_EIQA_DOC}
}

FILES_${PN} += "${TO_EIQA_SO}/* ${TO_EIQA_BIN}/* ${TO_EIQA_TUTORIAL}/*"
FILES_${PN}-dev += "${TO_EIQA_INC} ${TO_EIQA_CMAKE} ${TO_EIQA_TUTORIAL}/*"
#FILES_${PN}-doc += "${TO_EIQA_DOC}/*"

FILES_${PN}-staticdev += "${TO_EIQA_A}/*.a"
RDEPENDS_${PN}-dev += "${PN}-staticdev"
BBCLASSEXTEND = "native nativesdk"

ALLOW_EMPTY_${PN} = "1"
INSANE_SKIP_${PN}_append = "already-stripped"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_SYSROOT_STRIP = "1"
INSANE_SKIP_${PN} += "ldflags"
FILES_SOLIBSDEV = ""
