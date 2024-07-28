{ userSettings, ... }:
{
  imports =
    if userSettings.programs.editor == "nvim" then [ ./nvim/default.nix ] else [ ./helix/default.nix ];
}
