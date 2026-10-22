# Icons

Note: Icons are recommended to be 32x32 ([source](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/profile-appearance#icons)).

To resize icons run:

PowerShell:

```powershell
Get-ChildItem -Filter '*.ico' | ForEach-Object {
    magick $_.FullName -resize 32x32 -delete 1--1 $_.FullName
}
```

Bash:

```bash
for icon in ./*.ico; do
    [ -f "$icon" ] || continue
    magick "$icon" -resize 32x32 -delete 1--1 "$icon"
done
```

- [NixOS-WSL](https://github.com/nix-community/NixOS-WSL/blob/main/assets/NixOS-WSL.ico)
- [PowerShell](https://github.com/PowerShell/PowerShell/blob/master/assets/Powershell_black.ico)
- [Windows PowerShell](https://github.com/microsoft/terminal/blob/main/src/cascadia/CascadiaPackage/ProfileIcons/%7B61c54bbd-c2c6-5271-96e7-009a87ff44bf%7D.scale-200.png)
- [Command Prompt](https://github.com/microsoft/terminal/blob/main/res/console.ico)
