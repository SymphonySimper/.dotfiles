// based on: https://github.com/fthx/panel-free
import { panel, overview } from "resource:///org/gnome/shell/ui/main.js";

// refer (this._shownState): https://github.com/GNOME/gnome-shell/blob/main/js/ui/overview.js#L159
export default class HideTopPanelExtension {
  #show = () => {
    panel.visible = true;
  };

  #hide = () => {
    panel.visible = false;
  };

  enable() {
    // prevents hide on startup where the overview is open
    if (["HIDDEN", "HIDING"].includes(overview._shownState)) {
      this.#hide(); // required to hide the panel as soon as it's enabled
    }

    overview.connectObject("showing", this.#show, "hiding", this.#hide, this);
  }

  disable() {
    overview.disconnectObject(this);

    this.#show();
  }
}
