import { InjectionManager } from "resource:///org/gnome/shell/extensions/extension.js";
import { panel, overview } from "resource:///org/gnome/shell/ui/main.js";
import {
  Urgency,
  Source,
  MessageTray,
} from "resource:///org/gnome/shell/ui/messageTray.js";
import { Message } from "resource:///org/gnome/shell/ui/messageList.js";
import { Indicator } from "resource:///org/gnome/shell/ui/status/darkMode.js";

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

    // Avoid expanding notification if expanded
    this.#add(Message.prototype, "expand", (expand) => {
      return function (animate) {
        if (this.expanded) return;

        expand.call(this, animate);
      };
    });
  }

  disable() {
    this.#injectionManager.clear();
  }
}

export default class MyExtension {
  #extensions = [HidePanel, ShowOverviewOnEnable, Overrides].map(
    (extension) => new extension(),
  );

  enable() {
    this.#extensions.forEach((extension) => extension.enable());
  }

  disable() {
    this.#extensions.forEach((extension) => extension.disable());
  }
}
