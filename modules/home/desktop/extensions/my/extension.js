import { panel, overview } from "resource:///org/gnome/shell/ui/main.js";

// panel visiblity logic is based on: https://github.com/fthx/panel-free
export default class MyExtension {
  #showPanel = () => {
    panel.visible = true;
  };

  #hidePanel = () => {
    panel.visible = false;
  };

  enable() {
    // refer (this._shownState): https://github.com/GNOME/gnome-shell/blob/main/js/ui/overview.js#L159
    if (["HIDDEN", "HIDING"].includes(overview._shownState)) {
      overview.show();
    }

    overview.connectObject(
      "showing",
      this.#showPanel,
      "hiding",
      this.#hidePanel,
      this,
    );
  }

  disable() {
    overview.disconnectObject(this);

    this.#showPanel();
  }
}
