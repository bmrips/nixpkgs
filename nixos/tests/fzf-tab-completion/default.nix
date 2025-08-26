{ runTest }:

let
  runTestTemplate = args: runTest (import ./template.nix args);
in
{
  bash = runTestTemplate {
    name = "bash";
    extraConfig.programs.bash.enable = true;
    setup = ''machine.succeed("touch /root/aaa /root/bbb")'';
    completionTarget = "ls aaa";
    uniqueSubstring = "ls a";
    nonUniqueSubstring = "ls ";
  };

  nodejs = runTestTemplate {
    name = "nodejs";
    extraConfig =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.nodejs ];
      };
    setup = ''machine.send_chars("node\n")'';
    completionTarget = "stream";
    uniqueSubstring = "stre";
    nonUniqueSubstring = "s";
  };

  python3 = runTestTemplate {
    name = "python3";
    extraConfig =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.python3 ];
      };
    setup = ''machine.send_chars("python3\n")'';
    completionTarget = "print";
    uniqueSubstring = "pri";
    nonUniqueSubstring = "p";
  };

  readline = runTestTemplate {
    name = "readline";
    extraConfig =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.gdb ];
      };
    setup = ''machine.send_chars("gdb\n")'';
    completionTarget = "backtrace";
    uniqueSubstring = "back";
    nonUniqueSubstring = "b";
  };

  zsh = runTestTemplate {
    name = "zsh";
    extraConfig.programs.zsh.enable = true;
    setup = ''
      machine.succeed("touch /root/aaa /root/bbb")
      machine.send_chars("zsh\n")
    '';
    completionTarget = "ls aaa";
    uniqueSubstring = "ls a";
    nonUniqueSubstring = "ls ";
  };
}
