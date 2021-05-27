class Authoscope < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/authoscope"
  url "https://github.com/kpcyrd/authoscope/archive/v0.8.0.tar.gz"
  sha256 "977df6f08a2fece7076f362bc9db6686b829de93ed3c29806d7b841a50bd9d1c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3e471e7e4e1192a6a24328ca48eeb23214743aca9c9296cec9aebeb248db263"
    sha256 cellar: :any_skip_relocation, big_sur:       "31133f02d762c17de4ab1d60a27874a6c4f33cf4a677257e1b446872315b3195"
    sha256 cellar: :any_skip_relocation, catalina:      "df8dc24dfe3aa1ceabdd61fe783fb7edd8aa8de8ab558d98002e330eaf37ee50"
    sha256 cellar: :any_skip_relocation, mojave:        "5459ee6e2d462ebc1c7ea33f3139bbe9a482859876a9f163cf61e80fae9c12d6"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", *std_cargo_args
    man1.install "docs/authoscope.1"

    bash_output = Utils.safe_popen_read(bin/"authoscope", "completions", "bash")
    (bash_completion/"authoscope").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"authoscope", "completions", "zsh")
    (zsh_completion/"_authoscope").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"authoscope", "completions", "fish")
    (fish_completion/"authoscope.fish").write fish_output
  end

  test do
    (testpath/"true.lua").write <<~EOS
      descr = "always true"

      function verify(user, password)
          return true
      end
    EOS
    system "#{bin}/authoscope", "run", "-vvx", testpath/"true.lua", "foo"
  end
end
