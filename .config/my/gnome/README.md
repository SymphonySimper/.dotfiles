## Backup
- Full backup
```
dconf dump / > config
```
- For gnome only backup
```
dconf dump /org/gnome/ > gnome-config
```
## Load backup
- Full config
```
dconf load / < config
```
- Gnome only backup
```
dconf load /org/gnome/ < gnome-config
```
