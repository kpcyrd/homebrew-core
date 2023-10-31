class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/fc/24/23ffca4bfb74ee9ddc0a3b1fbae401a6ee3c02700ec457ddceffffce1ad9/dynaconf-3.2.4.tar.gz"
  sha256 "2e6adebaa587f4df9241a16a4bec3fda521154d26b15f3258fde753a592831b6"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e742f84c74b5a55b6c35dacc3ba4a9bbfbf6d22bbf69ca71c1545ca95bd166e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1542a2c33afc8b7f5bf82d0567bcbc8f05d96c05f628964912a28d2619f9b57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6526aa5bbf021af9e9a8ea6d63746ae3c5eb9928134f26839af971d6e463202e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a5bfd7e2d30d238b3412fd6c65803825fb4b9fdbef90a87ec1315ec4d207e45"
    sha256 cellar: :any_skip_relocation, ventura:        "ce8922ab39f253878c3a56efcbc99bf7556ebdf14083c62f78f422253d1a5ac7"
    sha256 cellar: :any_skip_relocation, monterey:       "04685ffff7af1f56a105879cedf1ed38e005c6d1deb06e7fdd86a75cd2662481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f008dcc13b8e488c34982a01f6786e439f358a22e8989e3744459b5467c07f1"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
