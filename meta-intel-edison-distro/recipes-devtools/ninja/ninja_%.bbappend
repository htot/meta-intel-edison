FILESEXTRAPATHS:prepend := "${THISDIR}/files/:"

SRC_URI:append = " \
	file://ninja.py \
	"

do_install:append() {
        mv ${D}${bindir}/ninja ${D}${bindir}/ninja.run
	install -D -m 0755  ${UNPACKDIR}/ninja.py ${D}${bindir}/ninja
}
