# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
# 3.*: https://github.com/jsonpickle/jsonpickle/issues/51
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="Python library for serializing any arbitrary object graph into JSON"
HOMEPAGE="https://jsonpickle.github.io/ https://github.com/jsonpickle/jsonpickle https://pypi.python.org/pypi/jsonpickle"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="test"

RDEPEND="$(python_abi_depend virtual/python-json[external])"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend dev-python/feedparser) )"

src_test() {
	testing() {
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" tests/runtests.py
	}
	python_execute_function testing
}
