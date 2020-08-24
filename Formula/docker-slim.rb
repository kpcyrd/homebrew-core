class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.32.0.tar.gz"
  sha256 "b47d1c6492e386aaca68991b7fd43f2d2139fd33bb8de03f09ae4b08ed721a5a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cac22eb1edd2f532d7778c8dbe61e0f77f0d86c80454aafeb9a36d8898bd564" => :catalina
    sha256 "1cac22eb1edd2f532d7778c8dbe61e0f77f0d86c80454aafeb9a36d8898bd564" => :mojave
    sha256 "1cac22eb1edd2f532d7778c8dbe61e0f77f0d86c80454aafeb9a36d8898bd564" => :high_sierra
  end

  depends_on "go" => :build

  skip_clean "bin/docker-slim-sensor"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/docker-slim/docker-slim/pkg/version.appVersionTag=#{version}"
    system "go", "build", "-trimpath", "-ldflags=#{ldflags}", "-o",
           bin/"docker-slim", "./cmd/docker-slim"

    # docker-slim-sensor is a Linux binary that is used within Docker
    # containers rather than directly on the macOS host.
    ENV["GOOS"] = "linux"
    system "go", "build", "-trimpath", "-ldflags=#{ldflags}", "-o",
           bin/"docker-slim-sensor", "./cmd/docker-slim-sensor"
    (bin/"docker-slim-sensor").chmod 0555
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-slim --version")
    system "test", "-x", bin/"docker-slim-sensor"
  end
end
