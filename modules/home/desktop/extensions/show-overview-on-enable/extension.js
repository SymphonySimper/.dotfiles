import { overview } from "resource:///org/gnome/shell/ui/main.js";

// refer (this._shownState): https://github.com/GNOME/gnome-shell/blob/main/js/ui/overview.js#L159
export default class ShowOverviewOnEnableExtension {
  enable() {
    if (["SHOWING", "SHOWN"].includes(overview._shownState)) return;
    overview.show();
  }

  disable() {
    if (["HIDDEN", "HIDING"].includes(overview._shownState)) return;
    overview.hide();
  }
}
