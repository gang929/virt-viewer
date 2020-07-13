FROM fedora:rawhide

RUN dnf update -y --nogpgcheck fedora-gpg-keys && \
    dnf update -y && \
    dnf install -y \
        augeas \
        autoconf \
        automake \
        bash \
        bash-completion \
        ca-certificates \
        ccache \
        chrony \
        cppi \
        dnsmasq \
        dwarves \
        ebtables \
        gcc \
        gdb \
        gettext-devel \
        git \
        glibc-langpack-en \
        gtk-doc \
        icoutils \
        intltool \
        iproute \
        iproute-tc \
        iscsi-initiator-utils \
        kmod \
        libtool \
        libwsman-devel \
        libxml2 \
        libxslt \
        lsof \
        lvm2 \
        make \
        meson \
        net-tools \
        nfs-utils \
        ninja-build \
        numad \
        parted \
        patch \
        perl \
        perl-App-cpanminus \
        polkit \
        python3 \
        python3-docutils \
        python3-flake8 \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        qemu-img \
        radvd \
        rpcgen \
        rpm-build \
        screen \
        scrub \
        sheepdog \
        strace \
        sudo \
        vala \
        vim \
        zfs-fuse && \
    dnf autoremove -y && \
    dnf clean all -y && \
    mkdir -p /usr/libexec/ccache-wrappers && \
    ln -s /usr/bin/ccache /usr/libexec/ccache-wrappers/i686-w64-mingw32-cc && \
    ln -s /usr/bin/ccache /usr/libexec/ccache-wrappers/i686-w64-mingw32-$(basename /usr/bin/gcc)

RUN dnf install -y \
        mingw32-curl \
        mingw32-dbus \
        mingw32-dlfcn \
        mingw32-gcc \
        mingw32-gdk-pixbuf \
        mingw32-gettext \
        mingw32-glib2 \
        mingw32-gnutls \
        mingw32-gstreamer1-plugins-bad-free \
        mingw32-gstreamer1-plugins-good \
        mingw32-gtk3 \
        mingw32-headers \
        mingw32-libgcrypt \
        mingw32-libgovirt \
        mingw32-libssh2 \
        mingw32-libxml2 \
        mingw32-pkg-config \
        mingw32-portablexdr \
        mingw32-readline \
        mingw32-rest \
        mingw32-spice-gtk3 && \
    dnf clean all -y

ENV LANG "en_US.UTF-8"

ENV MAKE "/usr/bin/make"
ENV NINJA "/usr/bin/ninja"
ENV PYTHON "/usr/bin/python3"

ENV CCACHE_WRAPPERSDIR "/usr/libexec/ccache-wrappers"

ENV ABI "i686-w64-mingw32"
ENV CONFIGURE_OPTS "--host=i686-w64-mingw32"
ENV MESON_OPTS "--cross-file=/usr/share/mingw/toolchain-mingw32.meson"

# Hack until https://bugzilla.redhat.com/show_bug.cgi?id=1856446 hits rawhide
RUN perl -i -p -e "s,\[binaries\],[binaries]\nlibgcrypt-config = '/usr/i686-w64-mingw32/sys-root/mingw/bin/libgcrypt-config'," /usr/share/mingw/toolchain-mingw32.meson
