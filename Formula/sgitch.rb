class Sgitch < Formula
  desc "Switch between GIT user profiles"
  homepage "https://gitlab.com/Timmy1e/sgitch"
  url "https://gitlab.com/Timmy1e/sgitch/-/archive/1.2.0/sgitch-1.2.0.tar.gz"
  sha256 "ec1be926cddee26021820aedcc26bb6f690ce231ba10abf4d09118570bbc11d1"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/timmy1e/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dd90601a552716842bc1f88fca0ecfd947c77ed4e820c3075a7e1524504c640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54292a315e87bbb980e75c589315195ed94b7c51aa980ca4a23e278eb8a15a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40f678a2f782ed2a162d78b9cdacf07441531a21a058c547e28c60fbde193eb3"
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
    assert_path_exists "new_config.yml"

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
