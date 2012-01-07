# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 2.5 *-jython"
DISTUTILS_SRC_TEST="py.test"

inherit distutils

DESCRIPTION="Python binding to libudev"
HOMEPAGE="http://packages.python.org/pyudev/ http://pypi.python.org/pypi/pyudev"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pygobject pyqt4 pyside"

RDEPEND=">=sys-fs/udev-151
	pygobject? ( $(python_abi_depend -e "*-pypy-*" dev-python/pygobject:2) )
	pyqt4? ( $(python_abi_depend -e "*-pypy-*" dev-python/PyQt4) )
	pyside? ( dev-python/pyside )"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend dev-python/mock) )"

DOCS="CHANGES.rst README.rst"

src_prepare() {
	distutils_src_prepare

	# Fix run_path.
	sed -i -e "s|== \('/run/udev'\)|in (\1, '/dev/.udev')|g" tests/test_core.py

	if ! use pygobject; then
		rm -f pyudev/glib.py
		sed -i -e "s|[, ]*GlibBinding()||g" tests/test_observer.py
	fi
	if ! use pyqt4; then
		rm -f pyudev/pyqt4.py
		sed -i -e "s|Qt4Binding('PyQt4')[, ]*||g" tests/test_observer.py
	fi
	if ! use pyside; then
		rm -f pyudev/pyside.py
		sed -i -e "s|Qt4Binding('PySide')[, ]*||g" tests/test_observer.py
	fi
	if ! use pyqt4 && ! use pyside; then
		rm -f pyudev/_qt_base.py
	fi
	if ! use pyqt4 && ! use pyside && ! use pygobject; then
		rm -f tests/test_observer.py
	fi
}
