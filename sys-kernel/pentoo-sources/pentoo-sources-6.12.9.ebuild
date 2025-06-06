# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="12"

inherit kernel-2
detect_version
detect_arch

DESCRIPTION="Pentoo kernel sources (kernel series ${KV_MAJOR}.${KV_MINOR})"
HOMEPAGE="https://github.com/pentoo/pentoo-overlay/tree/master/sys-kernel/pentoo-sources"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"
KEYWORDS="amd64 arm arm64 x86"
IUSE="experimental +lts"

src_unpack() {
	# default
	kernel-2_src_unpack
	# penpatches
	eapply -s "${FILESDIR}/4004_zd1211rw-inject+dbi-fix-4.7ish.patch"
	eapply -s "${FILESDIR}/4400_logo_larry_the_cow.patch"
	# https://gitlab.com/kalilinux/packages/linux/-/tree/kali/master/debian/patches/features/all
	eapply -s "${FILESDIR}/4005_kali-wifi-injection-without-4004.patch"
}

src_install() {
	kernel-2_src_install
	insinto /usr/share/${PN}
	if use amd64; then
		doins "${FILESDIR}"/config-amd64-${PVR}
	elif use x86; then
		doins "${FILESDIR}"/config-x86-${PVR}
	fi
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
	ewarn "The official pentoo kernel config is now installed with the kernel in /usr/share/pentoo-sources"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
