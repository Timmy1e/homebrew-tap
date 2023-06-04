class Ruri < Formula
  desc "Calculates the CRC-32 of files and checks them against their filename"
  homepage "https://gitlab.com/Timmy1e/ruri/"
  url "https://gitlab.com/Timmy1e/ruri/-/archive/v2.1.0/ruri-v2.1.0.tar.gz"
  sha256 "30ce2f395e3bfcf4891ef544f139d072466b8fff00b832a02d32bed4aa952f49"
  license "AGPL-3.0-or-later"

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
