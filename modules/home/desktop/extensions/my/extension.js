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

class ShowOverviewOnEnable {
  #states = new Set(["SHOWN", "SHOWING"]);

  enable() {
    // refer (this._shownState): https://github.com/GNOME/gnome-shell/blob/main/js/ui/overview.js#L159
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

class AltNum {
  #KEYBIND_NAMES = Array.from(
    Array(9)
      .keys()
      .map((i) => `focus-window-${i + 1}`),
  );

  #workspace = null;
  #windows = new Map();
  #ids = [];

  #resetWorkspace() {
    if (this.#workspace === null) return;

    this.#workspace.disconnectObject(this);
    this.#workspace = null;
  }

  #populateWindows() {
    const windows = global.display
      .get_tab_list(Meta.TabList.NORMAL_ALL, this.#workspace)
      .map((w) => [w.get_id(), w])
      .toSorted((a, b) => a[0] - b[0]);

    this.#windows = new Map(windows);
    this.#ids = this.#windows.keys().toArray();
  }

  #addWindow = (_, window) => {
    const id = window.get_id();
    if (this.#windows.has(id)) return; // not possible, but just for saftey

    this.#windows.set(id, window);
    this.#ids.push(id);
  };

  #removeWindow = (_, window) => {
    const id = window.get_id();
    if (!this.#windows.has(id)) return;

    this.#windows.delete(id);
    this.#ids.splice(this.#ids.indexOf(id), 1);
  };

  #updateWorkspace = () => {
    this.#resetWorkspace();

    this.#workspace = global.workspace_manager.get_active_workspace();

    this.#workspace.connectObject(
      "window-added",
      this.#addWindow,
      "window-removed",
      this.#removeWindow,
    );

    this.#populateWindows();
  };

  #activateWindow(index) {
    if (this.#windows.size <= index) return;

    this.#windows.get(this.#ids[index]).activate(0);
  }

  enable(settings) {
    this.#updateWorkspace();

    global.workspace_manager.connectObject(
      "active-workspace-changed",
      this.#updateWorkspace,
    );

    this.#KEYBIND_NAMES.entries().forEach(([index, name]) =>
      wm.addKeybinding(
        name,
        settings,
        Meta.KeyBindingFlags.NONE,
        Shell.ActionMode.ALL,
        () => {
          this.#activateWindow(index);
        },
      ),
    );
  }

  disable() {
    this.#resetWorkspace();
    this.#windows.clear();
    this.#ids = [];

    global.workspace_manager.disconnectObject(this);
    this.#KEYBIND_NAMES.forEach((name) => wm.removeKeybinding(name));
  }
}

export default class MyExtension extends Extension {
  #extensions = [ShowOverviewOnEnable, HidePanel, Overrides, AltNum].map(
    (extension) => new extension(),
  );

  enable() {
    const settings = this.getSettings();

    this.#extensions.forEach((extension) => extension.enable(settings));
  }

  disable() {
    this.#extensions.forEach((extension) => extension.disable());
  }
}
