import { InjectionManager } from "resource:///org/gnome/shell/extensions/extension.js";
import { panel, overview } from "resource:///org/gnome/shell/ui/main.js";
import { Urgency, Source } from "resource:///org/gnome/shell/ui/messageTray.js";

// panel visiblity logic is based on: https://github.com/fthx/panel-free
class HidePanel {
  #show = () => {
    panel.visible = true;
  };

  #hide = () => {
    panel.visible = false;
  };

  enable() {
    overview.connectObject("showing", this.#show, "hiding", this.#hide, this);
  }

  disable() {
    overview.disconnectObject(this);

    this.#show();
  }
}

class ShowOverviewOnEnable {
  enable() {
    // refer (this._shownState): https://github.com/GNOME/gnome-shell/blob/main/js/ui/overview.js#L159
    if (["HIDDEN", "HIDING"].includes(overview._shownState)) {
      overview.show();
    }
  }

  disable() {}
}

class MakeAllNotificationsAsCritical {
  #injectionManager = new InjectionManager();

  enable() {
    this.#injectionManager.overrideMethod(
      Source.prototype,
      "addNotification",
      (addNotification) => {
        return function (notification) {
          notification.urgency = Urgency.CRITICAL;
          addNotification.call(this, notification); // original method
        };
      },
    );
  }

  disable() {
    this.#injectionManager.clear();
  }
}

export default class MyExtension {
  #extensions = [
    HidePanel,
    ShowOverviewOnEnable,
    MakeAllNotificationsAsCritical,
  ].map((extension) => new extension());

  enable() {
    this.#extensions.forEach((extension) => extension.enable());
  }

  disable() {
    this.#extensions.forEach((extension) => extension.disable());
  }
}
