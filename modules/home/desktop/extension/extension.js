import {
  panel,
  overview,
  layoutManager,
} from "resource:///org/gnome/shell/ui/main.js";
import {
  Extension,
  InjectionManager,
} from "resource:///org/gnome/shell/extensions/extension.js";
import {
  Urgency,
  Source,
  MessageTray,
} from "resource:///org/gnome/shell/ui/messageTray.js";

class ShowOverviewOnEnable {
  #states = new Set(["SHOWN", "SHOWING"]);

  enable() {
    if (layoutManager._startingUp) return;
    if (this.#states.has(overview._shownState)) return;

    overview.show();
  }

  disable() {}
}

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

class Overrides {
  #injectionManager = new InjectionManager();

  #add(prototype, method, override) {
    this.#injectionManager.overrideMethod(prototype, method, override);
  }

  enable() {
    // Make all notifications as critical
    this.#add(Source.prototype, "addNotification", (addNotification) => {
      return function (notification) {
        notification.urgency = Urgency.CRITICAL;
        addNotification.call(this, notification); // original method
      };
    });

    // shows focus border and default action can be activated with enter / space
    this.#add(
      MessageTray.prototype,
      "_showNotification",
      (_showNotification) => {
        return function (actor, event) {
          _showNotification.call(this, actor, event);
          this._banner.can_focus = true;
        };
      },
    );
  }

  disable() {
    this.#injectionManager.clear();
  }
}

export default class MyExtension extends Extension {
  #extensions = [ShowOverviewOnEnable, HidePanel, Overrides].map(
    (extension) => new extension(),
  );

  enable() {
    this.#extensions.forEach((extension) => extension.enable());
  }

  disable() {
    this.#extensions.forEach((extension) => extension.disable());
  }
}
