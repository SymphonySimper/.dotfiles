import Gio from "gi://Gio";
import St from "gi://St";

import { overview } from "resource:///org/gnome/shell/ui/main.js";
import { Extension } from "resource:///org/gnome/shell/extensions/extension.js";

const SEARCH_URL = "https://p1a.in/?q=";

export default class WebSearchExtension extends Extension {
  get id() {
    return this.uuid;
  }

  get appInfo() {
    return Gio.AppInfo.get_default_for_uri_scheme("https");
  }

  get canLaunchSearch() {
    return true;
  }

  enable() {
    overview.searchController.addProvider(this);

    const searchResults = overview.searchController._searchResults;
    const providers = searchResults._providers;
    const providerIndex = providers.indexOf(this);

    if (providerIndex === -1) return;

    providers.splice(providerIndex, 1);
    providers.splice(1, 0, this);
    searchResults._content.set_child_at_index(this.display, 1);
  }

  disable() {
    overview.searchController.removeProvider(this);
    this.display = null;
  }

  getInitialResultSet(terms, cancellable) {
    if (cancellable.is_cancelled()) return [];

    const query = terms.join(" ");

    return query ? [query] : [];
  }

  getSubsearchResultSet(_results, terms, cancellable) {
    return this.getInitialResultSet(terms, cancellable);
  }

  getResultMetas(results) {
    return results.map((query) => ({
      id: query,
      name: `Search the web for “${query}”`,
      description: "p1a.in",
      createIcon: (size) =>
        new St.Icon({
          icon_name: "web-browser-symbolic",
          icon_size: size,
        }),
    }));
  }

  filterResults(results, maxResults) {
    return results.slice(0, maxResults);
  }

  launchSearch(terms) {
    this.activateResult(terms.join(" "));
  }

  activateResult(query) {
    Gio.AppInfo.launch_default_for_uri(
      `${SEARCH_URL}${encodeURIComponent(query)}`,
      null,
    );
  }
}
