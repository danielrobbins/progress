# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"

inherit distutils

DESCRIPTION="Exclude specific directories from nosetests runs."
HOMEPAGE="http://pypi.python.org/pypi/nose-exclude"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="$(python_abi_depend dev-python/nose)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

PYTHON_MODULES="nose_exclude.py"
