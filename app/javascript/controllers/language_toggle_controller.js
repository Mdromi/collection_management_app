// app/javascript/controllers/language_toggle_controller.js

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["icon"];

  connect() {
    // Show the icon corresponding to the current locale on page load
    this.updateIcon();
  }

  toggle() {
    const currentLocale = document.documentElement.lang;
    const newLocale = currentLocale === "en" ? "de" : "en";
    
    // Set the new locale in a cookie
    document.cookie = `locale=${newLocale}; path=/`;

    // Reload the page to apply the new locale
    location.reload();
  }

  updateIcon() {
    // Get the current locale
    const currentLocale = document.documentElement.lang;

    // Get all icon elements within the button
    const icons = this.iconTargets;

    // Hide all icons
    icons.forEach(icon => icon.style.display = "none");

    // Show only the icon corresponding to the current locale
    const currentLocaleIcon = icons.find(icon => icon.dataset.locale === currentLocale);
    if (currentLocaleIcon) {
      currentLocaleIcon.style.display = "block";
    }
  }
}
