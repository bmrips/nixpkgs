{ lib, ... }:

{
  name = "fzf-tab-completion-readline";

  meta.maintainers = [ lib.maintainers.bmrips ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.gdb ];
      programs.fzf-tab-completion.enable = true;
      services.getty.autologinUser = "root";
    };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.send_chars("gdb\n")

    # Complete a unique candidate
    machine.send_chars("back")
    machine.send_key("tab")
    machine.wait_until_tty_matches("1", "backtrace", 5)

    # Complete a non-unique candidate through fuzzy matching
    machine.send_chars("b")
    machine.send_key("tab")
    machine.send_chars("ack")
    machine.send_key("enter")
    machine.wait_until_tty_matches("1", "backtrace", 5)
  '';
}
