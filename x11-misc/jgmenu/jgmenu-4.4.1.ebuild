# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A simple, independent and contemporary-looking X11 menu"
HOMEPAGE="https://github.com/johanmalm/jgmenu"
SRC_URI="https://github.com/johanmalm/jgmenu/archive/v${PV}/jgmenu-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="x11-libs/libX11 \
	x11-libs/libXrandr \
	x11-libs/cairo \
	x11-libs/pango \
	gnome-base/librsvg \
	dev-libs/glib"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	econf \
		--prefix="${EPREFIX}"/usr
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
