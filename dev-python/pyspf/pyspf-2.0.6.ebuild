# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 2.5"

inherit distutils

DESCRIPTION="SPF (Sender Policy Framework) implemented in Python."
HOMEPAGE="http://pypi.python.org/pypi/pyspf"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz mirror://sourceforge/pymilter/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(python_abi_depend -i "2.*" dev-python/pydns:2)
	$(python_abi_depend -i "3.*" dev-python/pydns:3)"
RDEPEND="${DEPEND}"

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"
PYTHON_MODULES="spf.py"

src_prepare() {
	distutils_src_prepare

	preparation() {
		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			2to3-${PYTHON_ABI} -nw --no-diffs spf.py
		fi
	}
	python_execute_function -s preparation
}

src_test() {
	testing() {
		pushd test > /dev/null
		python_execute PYTHONPATH="../build/lib" "$(PYTHON)" testspf.py || return
		popd > /dev/null
	}
	python_execute_function -s testing
}
