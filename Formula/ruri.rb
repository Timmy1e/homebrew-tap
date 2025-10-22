class Ruri < Formula
  desc "Calculates the CRC-32 of files and checks them against their filename"
  homepage "https://gitlab.com/Timmy1e/ruri/"
  url "https://gitlab.com/Timmy1e/ruri/-/archive/v2.1.1/ruri-v2.1.1.tar.gz"
  sha256 "5a2341444a6165360035f1b6e04d782f2bcc79fc46d13502166108093691a3b1"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/timmy1e/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36ad832de92a83d0ced4af720167d5f74f4327165d19c63e782871b46c40ea9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96a56bed2205af2d82a53900225b8a3d44397fef7b1c1b66c151c2332ac358e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab6addacc2401e5a1b25b663221f3385be7d2b15d9eb63aed45d57a1615186b2"
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
