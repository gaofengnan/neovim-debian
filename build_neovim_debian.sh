#!/bin/bash
# Build the neovim binary packages (.deb), one set for every suite. The build
# runs on bookworm, the oldest Debian suite served, so the dependencies
# dh_shlibdeps resolves (libc6, libgcc-s1) hold on every newer suite too; only
# the old ~<suite> version suffix ever differed between the per-suite builds.
# The fixed ~gaofn keeps it below the distro's own build of the same version.
#
# Produces, in ./out :
#   neovim_<ver>-<build>~gaofn_amd64.deb
#   neovim-unstripped_<ver>-<build>~gaofn_amd64.deb
#   neovim-runtime_<ver>-<build>~gaofn_all.deb
#
# Usage: ./build_neovim_debian.sh <neovim_version> <build_version>
set -euo pipefail

VERSION="${1:-}"
BUILD="${2:-}"
if [ -z "$VERSION" ] || [ -z "$BUILD" ]; then
    echo "Usage: $0 <neovim_version> <build_version>" >&2
    echo "Example: $0 0.12.4 1" >&2
    exit 1
fi

FULL_VERSION="${VERSION}-${BUILD}~gaofn"

mkdir -p out

echo "==> Building neovim ${FULL_VERSION}"

# Generate the changelog (overwrites the placeholder).
cat > debian/changelog << EOF2
neovim (${FULL_VERSION}) stable; urgency=medium

  * New upstream release ${VERSION}.

 -- Fengnan Gao <gao.fengnan@gmail.com>  $(date -R)
EOF2

docker build -t "neovim-build" -f Dockerfile .

cid="$(docker create "neovim-build")"
docker cp "${cid}:/out/." ./out/
docker rm "${cid}" > /dev/null

echo ""
echo "Built packages:"
ls -la out/*.deb
