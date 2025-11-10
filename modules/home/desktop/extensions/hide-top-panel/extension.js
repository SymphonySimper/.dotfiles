// based on: https://github.com/fthx/panel-free
import { panel, overview } from "resource:///org/gnome/shell/ui/main.js";

export default class HideTopPanelExtension {
  #show = () => {
    panel.visible = true;
  };

  #hide = () => {
    panel.visible = false;
  };

  enable() {
    this.#hide(); // required to hide the panel as soon as it's enabled

    overview.connectObject("showing", this.#show, "hiding", this.#hide, this);
  }

  disable() {
    overview.disconnectObject(this);

    this.#show();
  }
}
