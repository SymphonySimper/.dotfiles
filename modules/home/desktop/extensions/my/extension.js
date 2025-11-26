import {
  Extension,
  InjectionManager,
} from "resource:///org/gnome/shell/extensions/extension.js";
import { panel, overview } from "resource:///org/gnome/shell/ui/main.js";
import {
  Urgency,
  Source,
  MessageTray,
} from "resource:///org/gnome/shell/ui/messageTray.js";
import { Message } from "resource:///org/gnome/shell/ui/messageList.js";

export default class MyExtension extends Extension {
  #im = new InjectionManager();

  #showPanel = () => {
    panel.visible = true;
  };

  #hidePanel = () => {
    panel.visible = false;
  };

  #enableHidePanel() {
    // panel visiblity logic is based on: https://github.com/fthx/panel-free
    overview.connectObject(
      "showing",
      this.#showPanel,
      "hiding",
      this.#hidePanel,
      this,
    );
  }

  #disableHidePanel() {
    overview.disconnectObject(this);

    this.#showPanel();
  }

  #showOverview() {
    // refer (this._shownState): https://github.com/GNOME/gnome-shell/blob/main/js/ui/overview.js#L159
    if (["HIDDEN", "HIDING"].includes(overview._shownState)) {
      overview.show();
    }
  }

  #enableOverrides() {
    // Make all notifications as critical
    this.#im.overrideMethod(
      Source.prototype,
      "addNotification",
      (addNotification) => {
        return function (notification) {
          notification.urgency = Urgency.CRITICAL;
          addNotification.call(this, notification); // original method
        };
      },
    );

    // shows focus border and default action can be activated with enter / space
    this.#im.overrideMethod(
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
    this.#im.overrideMethod(Message.prototype, "expand", (expand) => {
      return function (animate) {
        if (this.expanded) return;

        expand.call(this, animate);
      };
    });
  }

  #disableOverrides() {
    this.#im.clear();
  }

  enable() {
    this.#enableHidePanel();
    this.#showOverview();
    this.#enableOverrides();
  }

  disable() {
    this.#disableHidePanel();
    this.#disableOverrides();
  }
}
