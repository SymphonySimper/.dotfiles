import GLib from "gi://GLib";
import Gio from "gi://Gio";
import UPower from "gi://UPowerGlib";

import { loadInterfaceXML } from "resource:///org/gnome/shell/misc/fileUtils.js";
import {
  overview,
  layoutManager,
} from "resource:///org/gnome/shell/ui/main.js";
import {
  Extension,
  InjectionManager,
} from "resource:///org/gnome/shell/extensions/extension.js";
import {
  Urgency,
  MessageTray,
  Notification,
  NotificationDestroyedReason,
  getSystemSource,
} from "resource:///org/gnome/shell/ui/messageTray.js";

// refer: notify function
// source: https://gitlab.gnome.org/GNOME/gnome-shell/-/blob/main/js/ui/main.js#L634-647
function notify(params) {
  const source = getSystemSource();
  const notification = new Notification({
    source,
    title: params.msg,
    body: params.details ?? null,
    isTransient: params.isTransient ?? true,
    urgency: params.urgency ?? Urgency.NORMAL,
  });
  source.addNotification(notification);
  return notification;
}

class ShowOverviewOnEnable {
  #states = new Set(["SHOWN", "SHOWING"]);

  enable() {
    if (layoutManager._startingUp) return;
    if (this.#states.has(overview._shownState)) return;

    overview.show();
  }

  disable() {}
}

class Overrides {
  #injectionManager = new InjectionManager();

  #add(prototype, method, override) {
    this.#injectionManager.overrideMethod(prototype, method, override);
  }

  enable() {
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

const DisplayDeviceProxy = Gio.DBusProxy.makeProxyWrapper(
  loadInterfaceXML("org.freedesktop.UPower.Device"),
);

class Battery {
  #MIN = 40;
  #MAX = 80;
  #SNOOZE = 5 * 60; // 5 * 60s = 5min

  #proxy = null;
  #notification = null;
  #snoozeId = 0;

  enable() {
    this.#proxy = new DisplayDeviceProxy(
      Gio.DBus.system,
      "org.freedesktop.UPower",
      "/org/freedesktop/UPower/devices/DisplayDevice",
      (proxy, error) => {
        // disabled (or re-enabled) before the proxy finished loading
        if (this.#proxy !== proxy) return;
        if (error) {
          console.error(error);
          return;
        }

        proxy.connectObject("g-properties-changed", () => this.#sync(), this);
        this.#sync();
      },
    );
  }

  #sync() {
    const { Percentage: level, State: state } = this.#proxy;

    let msg = null;
    if (level < this.#MIN && state === UPower.DeviceState.DISCHARGING) {
      msg = `Battery is less than ${this.#MIN}% (${level}%) plug the charger.`;
    } else if (level > this.#MAX && state === UPower.DeviceState.CHARGING) {
      msg = `Battery is greater than ${this.#MAX}% (${level}%) unplug the charger`;
    }

    // condition cleared (plugged in / unplugged / full) -> remove it
    if (!msg) {
      this.#notification?.destroy(NotificationDestroyedReason.SOURCE_CLOSED);
      return;
    }

    // already showing -> just update the text, don't stack a new one
    if (this.#notification) {
      this.#notification.title = msg;
      return;
    }

    // dismissed recently -> wait for the snooze to end
    if (this.#snoozeId) return;

    this.#notification = notify({
      msg,
      urgency: Urgency.CRITICAL,
      isTransient: false,
    });
    this.#notification.connect("destroy", (_notification, reason) => {
      this.#notification = null;
      if (reason !== NotificationDestroyedReason.DISMISSED) return;

      this.#snoozeId = GLib.timeout_add_seconds(
        GLib.PRIORITY_DEFAULT,
        this.#SNOOZE,
        () => {
          this.#snoozeId = 0;
          this.#sync();
          return GLib.SOURCE_REMOVE;
        },
      );
    });
  }

  disable() {
    this.#proxy?.disconnectObject(this);
    this.#proxy = null;
    this.#notification?.destroy(NotificationDestroyedReason.SOURCE_CLOSED);

    if (this.#snoozeId) {
      GLib.Source.remove(this.#snoozeId);
      this.#snoozeId = 0;
    }
  }
}

export default class MyExtension extends Extension {
  #extensions = [ShowOverviewOnEnable, Overrides, Battery].map(
    (extension) => new extension(),
  );

  enable() {
    this.#extensions.forEach((extension) => extension.enable());
  }

  disable() {
    this.#extensions.forEach((extension) => extension.disable());
  }
}
