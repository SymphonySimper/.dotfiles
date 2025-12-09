import GLib from "gi://GLib";
import UPower from "gi://UPowerGlib";

import {
  panel,
  overview,
  layoutManager,
  notify,
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

class Battery {
  #MIN = 40;
  #MAX = 80;

  enable() {
    this._sourceId = GLib.timeout_add_seconds(GLib.PRIORITY_LOW, 5 * 60, () => {
      const { Percentage: level, State: state } =
        panel.statusArea.quickSettings._system._systemItem._powerToggle._proxy;

      if (level < this.#MIN && state === UPower.DeviceState.DISCHARGING) {
        notify(
          `Battery is less than ${this.#MIN}% (${level}%) plug the charger.`,
        );
      } else if (level > this.#MAX && state === UPower.DeviceState.CHARGING) {
        notify(
          `Battery is greater than ${this.#MAX}% (${level}%) unplug the charger`,
        );
      }

      return GLib.SOURCE_CONTINUE;
    });
  }

  disable() {
    if (this._sourceId) {
      GLib.Source.remove(this._sourceId);
      this._sourceId = null;
    }
  }
}

export default class MyExtension extends Extension {
  #extensions = [ShowOverviewOnEnable, HidePanel, Overrides, Battery].map(
    (extension) => new extension(),
  );

  enable() {
    this.#extensions.forEach((extension) => extension.enable());
  }

  disable() {
    this.#extensions.forEach((extension) => extension.disable());
  }
}
