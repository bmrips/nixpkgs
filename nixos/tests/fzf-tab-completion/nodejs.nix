{ lib, ... }:

{
  name = "fzf-tab-completion-nodejs";

  meta.maintainers = [ lib.maintainers.bmrips ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.nodejs ];
      programs.fzf-tab-completion.enable = true;
      services.getty.autologinUser = "root";
    };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.send_chars("node\n")

    # Complete a unique candidate
    machine.send_chars("stre")
    machine.send_key("tab")
    machine.wait_until_tty_matches("1", "stream", 5)

    # Complete a non-unique candidate through fuzzy matching
    machine.send_chars("s")
    machine.send_key("tab")
    machine.send_chars("tre")
    machine.send_key("enter")
    machine.wait_until_tty_matches("1", "stream", 5)
  '';
}
