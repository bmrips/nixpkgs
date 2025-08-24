{ lib, ... }:

{
  name = "fzf-tab-completion-python3";

  meta.maintainers = [ lib.maintainers.bmrips ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.python3 ];
      programs.fzf-tab-completion.enable = true;
      services.getty.autologinUser = "root";
    };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.send_chars("python3\n")

    # Complete a unique candidate
    machine.send_chars("pri")
    machine.send_key("tab")
    machine.wait_until_tty_matches("1", "print", 5)

    # Complete a non-unique candidate through fuzzy matching
    machine.send_chars("p")
    machine.send_key("tab")
    machine.send_chars("ri")
    machine.send_key("enter")
    machine.wait_until_tty_matches("1", "print", 5)
  '';
}
