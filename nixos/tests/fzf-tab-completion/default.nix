{ runTest }:

{
  bash = runTest ./bash.nix;
  nodejs = runTest ./nodejs.nix;
  python = runTest ./python.nix;
  readline = runTest ./readline.nix;
  zsh = runTest ./zsh.nix;
}
