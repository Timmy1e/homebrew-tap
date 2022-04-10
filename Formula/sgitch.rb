class Sgitch < Formula
  desc "Switch between GIT user profiles"
  homepage "https://gitlab.com/Timmy1e/sgitch"
  url "https://gitlab.com/Timmy1e/sgitch/-/archive/1.2.0/sgitch-1.2.0.tar.gz"
  sha256 "ec1be926cddee26021820aedcc26bb6f690ce231ba10abf4d09118570bbc11d1"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/timmy1e/tap"
    sha256 cellar: :any_skip_relocation, big_sur:      "1bda557e7a02db12f22d58405d19b7b0e473673e062c315b126081ab8d288145"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "908e7c02e7f8b2c0ad9dae7c823efb3a8989cda7b3a784971dcbf11d6f6479f1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match(
      "Successfully created config file at \"new_config.yml\".\n",
      shell_output("#{bin}/sgitch --config new_config.yml init"),
    )
    assert_predicate testpath/"new_config.yml", :exist?

    File.write("test_config.yml", "profiles:
  profile1:
    name: User Name
    email: user.name@domain.tld
    signing:
      isenabled: true
      key: SOME_KEY")
    assert_match(
      "Profiles found in \"test_config.yml\":

profile1:
  Name:    User Name
  Email:   user.name@domain.tld
  Signing:
    Enabled: true
    Key:     SOME_KEY\n",
      shell_output("#{bin}/sgitch --config test_config.yml profiles"),
    )
  end
end
