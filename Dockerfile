FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Build environment: bookworm, the oldest Debian suite served. dh_shlibdeps
# resolves the prebuilt binary's dependencies (libc6, libgcc-s1) against its
# libraries, so the declared versions hold on every suite.
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        debhelper \
        dpkg-dev \
        wget \
        ca-certificates \
        xz-utils \
        file \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY . /build/

# debian/rules downloads the upstream prebuilt tarball during the build.
RUN chmod +x debian/rules && dpkg-buildpackage -b -us -uc -Zxz

RUN mkdir -p /out && cp ../neovim*.deb /out/
