# Icons

Note: Icons are recommended to be 32x32 ([source](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/profile-appearance#icons)).

To resize icons run:

```nu
glob *.ico | each {|icon| magick $icon -resize 32x32 -delete 1--1 $icon } | ignore
```

- [NixOS-WSL](https://github.com/nix-community/NixOS-WSL/blob/main/assets/NixOS-WSL.ico)
- [PowerShell](https://github.com/PowerShell/PowerShell/blob/master/assets/Powershell_black.ico)
- [Command Prompt](https://github.com/microsoft/terminal/blob/main/res/console.ico)
