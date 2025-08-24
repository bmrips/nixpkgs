{ lib, ... }:

{
  name = "fzf-tab-completion-bash";

  meta.maintainers = [ lib.maintainers.bmrips ];

  nodes.machine = {
    programs.fzf-tab-completion.enable = true;
    programs.bash.enable = true;
    services.getty.autologinUser = "root";
  };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.succeed("touch /root/aaa /root/bbb")

    # Complete a unique candidate
    machine.send_chars("ls a")
    machine.send_key("tab")
    machine.wait_until_tty_matches("1", "ls aaa", 5)

    # Complete a non-unique candidate through fuzzy matching
    machine.send_chars("ls ")
    machine.send_key("tab")
    machine.send_chars("a")
    machine.send_key("enter")
    machine.wait_until_tty_matches("1", "ls aaa", 5)
  '';
}
