# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
# 2.5: https://bitbucket.org/tarek/distribute/issue/318
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="2.5 *-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils eutils

MY_PN="distribute"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Distribute (fork of Setuptools) is a collection of extensions to Distutils"
HOMEPAGE="https://bitbucket.org/pypa/setuptools https://pypi.python.org/pypi/distribute"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DOCS="README.txt docs/easy_install.txt docs/pkg_resources.txt docs/setuptools.txt"
PYTHON_MODULES="_markerlib easy_install.py pkg_resources.py setuptools"

src_prepare() {
	distutils_src_prepare

	epatch "${FILESDIR}/distribute-0.6.16-fix_deprecation_warnings.patch"

	# Disable installation of Windows-specific files.
	sed -e "/package_data =/{s/'\*.exe', //;s/, 'setuptools.command':\['\*.xml'\]//}" -i setup.py

	# Disable tests requiring network connection.
	rm -f setuptools/tests/test_packageindex.py
}

src_test() {
	# test_install_site_py fails with disabled byte-compiling in Python 2.7 / >=3.2.
	python_enable_pyc

	distutils_src_test

	python_disable_pyc

	find -name "__pycache__" -print0 | xargs -0 rm -fr
	find "(" -name "*.pyc" -o -name "*\$py.class" ")" -delete
}

src_install() {
	DISTRIBUTE_DISABLE_VERSIONED_EASY_INSTALL_SCRIPT="1" DONT_PATCH_SETUPTOOLS="1" distutils_src_install
}
