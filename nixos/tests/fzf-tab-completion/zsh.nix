{ lib, ... }:

{
  name = "fzf-tab-completion-zsh";

  meta.maintainers = [ lib.maintainers.bmrips ];

  nodes.machine = {
    programs.fzf-tab-completion.enable = true;
    programs.zsh.enable = true;
    services.getty.autologinUser = "root";
  };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.succeed("touch /root/aaa /root/bbb")
    machine.send_chars("zsh\n")

    # Complete a unique candidate
    machine.send_chars("ls a")
    machine.send_key("tab")
    machine.wait_until_tty_matches("1", "aaa", 5)

    # Complete a non-unique candidate through fuzzy matching
    machine.send_chars("ls ")
    machine.send_key("tab")
    machine.send_chars("a")
    machine.send_key("enter")
    machine.wait_until_tty_matches("1", "aaa", 5)
  '';
}
