# dotfiles
This is my personal NixOS configuration repo.

## Building
Writing this down just in case I forget how to do it. There is probably a MUCH better way to do this, but this is what I got.
If this is the first time building the NixOS config on a new machine, you will need to do the following:

- Download this repo, rename it to `.dotfiles`, and put it into your home directory. Final path should be `~/.dotfiles`.
- Make a `secret-key.txt` file in the root of this repo and write the key in there.
- run `sudo NIX_CONFIG="access-tokens = github.com=ghp_YourTokenHere" nixOS-rebuild switch --flake .#YourHostName --impure`

After that, you should be able to run `nixOS-rebuild switch --flake .#YourHostName --impure` without the access tokens. It still needs the `--impure` flag to have access to the home directory, but it should be able to read the `secret-key.txt` file and decrypt the secrets in the NixOS config. If you need to edit the secrets, there is a zsh alias `sops-edit` that needs to be run from the root of this repo.

This might look redundant, but it's a one-time setup. It should manage the secrets and dotfiles automatically after this, and I won't have to worry about it again (except when the token expires or I get a new machine).
