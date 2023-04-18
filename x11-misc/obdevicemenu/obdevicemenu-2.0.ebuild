# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="OpenBox device menu"
HOMEPAGE="https://github.com/uriel1998/obdevicemenu_udisks2_bash"
SRC_URI="https://github.com/uriel1998/obdevicemenu_udisks2_bash/archive/refs/heads/master.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="notifications"

DEPEND="
	app-shells/bash
	sys-apps/dbus
	x11-wm/openbox
	sys-fs/udisks
	notifications? ( x11-misc/notification-daemon )
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/obdevicemenu_udisks2_bash-master"

src_unpack() {
    if [ "${A}" != "" ]; then
        unpack ${A}
    fi
}

src_install() {
    mv ${S}/config ${S}/obdevicemenu.conf
    insinto /etc
    doins obdevicemenu.conf || die
    exeinto /usr/sbin
    doexe obdevicemenu || die
}
