class CurlRustls < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server (with rustls)"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  url "https://curl.se/download/curl-8.9.1.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_9_1/curl-8.9.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.9.1.tar.bz2"
  sha256 "b57285d9e18bf12a5f2309fc45244f6cf9cb14734e7454121099dd0a83d669a3"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  head do
    url "https://github.com/curl/curl.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "ca-certificates"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libssh2"
  depends_on "rtmpdump"
  depends_on "rustls-ffi"
  depends_on "zstd"

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    tag_name = "curl-#{version.to_s.tr(".", "_")}"
    if build.stable? && stable.mirrors.grep(/github\.com/).first.exclude?(tag_name)
      odie "Tag name #{tag_name} is not found in the GitHub mirror URL! " \
           "Please make sure the URL is correct."
    end

    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-ldap
      --disable-ldaps
      --disable-manual
      --disable-shared
      --disable-silent-rules
      --prefix=#{prefix}
      --with-rustls
      --without-openssl
      --with-ca-bundle=#{Formula["ca-certificates"].pkgetc/"cert.pem"}
      --without-ca-path
      --with-default-ssl-backend=rustls
      --with-libidn2
      --with-librtmp
      --with-libssh2
      --without-libpsl
      --with-zsh-functions-dir=#{zsh_completion}
      --with-fish-functions-dir=#{fish_completion}
    ]

    args << if OS.mac?
      "--with-gssapi"
    else
      "--with-gssapi=#{Formula["krb5"].opt_prefix}"
    end

    system "./configure", *args
    system "make"

    (lib/"curl-rustls").install "src/curl"
    bin.install_symlink lib/"curl-rustls/curl" => "curl-rustls"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system bin/"curl-rustls", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum
  end
end