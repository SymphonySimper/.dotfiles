import Meta from "gi://Meta";
import Shell from "gi://Shell";

import { panel, overview, wm } from "resource:///org/gnome/shell/ui/main.js";
import {
  Extension,
  InjectionManager,
} from "resource:///org/gnome/shell/extensions/extension.js";
import {
  Urgency,
  Source,
  MessageTray,
} from "resource:///org/gnome/shell/ui/messageTray.js";
import { Message } from "resource:///org/gnome/shell/ui/messageList.js";

export default class MyExtension extends Extension {
  #settings = null;

  #im = new InjectionManager();

  #focusWindowKeybindNames = Array.from(
    Array(9)
      .keys()
      .map((i) => `focus-window-${i + 1}`),
  );
  #focusWindowList = [];
  #focusedWorkspace = null;

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

  #focusWindow(index) {
    if (this.#focusWindowList.length <= index) return;

    this.#focusWindowList[index].activate(0);
  }

  #updateFocusWindowList = () => {
    if (this.#focusedWorkspace !== null) {
      this.#focusedWorkspace.disconnectObject(this);
    }

    this.#focusedWorkspace = global.workspace_manager.get_active_workspace();

    this.#focusedWorkspace.connectObject(
      "window-added",
      this.#updateFocusWindowList,
      "window-removed",
      this.#updateFocusWindowList,
    );

    this.#focusWindowList = global.display
      .get_tab_list(Meta.TabList.NORMAL_ALL, this.#focusedWorkspace)
      .toSorted((a, b) => a.get_id() - b.get_id());
  };

  #enableFocusWindowKeybinds() {
    this.#updateFocusWindowList();

    global.workspace_manager.connectObject(
      "active-workspace-changed",
      this.#updateFocusWindowList,
    );

    this.#focusWindowKeybindNames.entries().forEach(([index, name]) =>
      wm.addKeybinding(
        name,
        this.#settings,
        Meta.KeyBindingFlags.NONE,
        Shell.ActionMode.ALL,
        () => {
          this.#focusWindow(index);
        },
      ),
    );
  }

  #disableFocusWindowKeybinds() {
    global.workspace_manager.disconnectObject(this);

    this.#focusedWorkspace = null;
    this.#focusWindowList = [];
    this.#focusWindowKeybindNames.forEach((name) => wm.removeKeybinding(name));
  }

  enable() {
    this.#settings = this.getSettings();

    this.#enableHidePanel();
    this.#showOverview();
    this.#enableOverrides();
    this.#enableFocusWindowKeybinds();
  }

  disable() {
    this.#settings = null;

    this.#disableHidePanel();
    this.#disableOverrides();
    this.#disableFocusWindowKeybinds();
  }
}
