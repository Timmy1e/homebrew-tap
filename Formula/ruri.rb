class Ruri < Formula
  desc "Calculates the CRC-32 of files and checks them against their filename"
  homepage "https://gitlab.com/Timmy1e/ruri/"
  url "https://gitlab.com/Timmy1e/ruri/-/archive/v2.0.1/ruri-v2.0.1.tar.gz"
  sha256 "ef7883661b0f145b6bf9b7d6be172b2c17198003625f28ce7950065d489f5a20"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/timmy1e/tap"
    sha256 cellar: :any_skip_relocation, big_sur:      "e08280cc2473a4408e803d3d71260b5fc5fe468feb55cd640608e7fdba0fa238"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d3c7bee6d817275872117c43b3b8e7be2f09f0026bcc59cccf1b6f379d3861d9"
  end

  head do
    url "https://gitlab.com/Timmy1e/ruri.git", branch: "master"
  end

  depends_on "rust" => :build

  def install
    system("cargo", "install", *std_cargo_args, "--bin", "ruri")
    prefix.install_metafiles
  end

  test do
    File.write("file_one[367B63B8].txt", "This is a homebrew test file\n")
    assert_match(
      "367B63B8  file_one[367B63B8].txt\n",
      shell_output("#{bin}/ruri -q file_one[367B63B8].txt"),
    )

    File.write("file_two[FEB9A153].txt", "This is another test file\n")
    assert_match(
      /✓ 1  ⁉ 0  × 0  ‼ 0  ⏲ (\d+(h|m|[mun]?s) )+\n/,
      shell_output("#{bin}/ruri file_two[FEB9A153].txt"),
    )
  end
end
