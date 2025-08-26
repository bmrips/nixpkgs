{
  name,
  extraConfig ? {},
  setup,
  completionTarget,
  uniqueSubstring,
  nonUniqueSubstring,
}:

{ lib, ... }:
{
  name = "fzf-tab-completion-${name}";

  meta.maintainers = [ lib.maintainers.bmrips ];

  nodes.machine =
    { config, lib, pkgs, ...}@args:
    {
      programs.fzf-tab-completion.enable = true;
      services.getty.autologinUser = "root";
    }
    // (if builtins.isAttrs extraConfig then extraConfig else extraConfig args);

  testScript = ''
    machine.wait_for_unit("default.target")
    ${setup}

    # Complete a unique candidate
    machine.send_chars("${uniqueSubstring}")
    machine.send_key("tab")
    machine.wait_until_tty_matches("1", "${completionTarget}", 5)

    # Complete a non-unique candidate through fuzzy matching
    machine.send_chars("${nonUniqueSubstring}")
    machine.send_key("tab")
    machine.send_chars("${lib.removePrefix nonUniqueSubstring uniqueSubstring}")
    machine.send_key("enter")
    machine.wait_until_tty_matches("1", "${completionTarget}", 5)
  '';
}
