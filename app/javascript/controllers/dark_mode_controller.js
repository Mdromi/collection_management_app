import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["icon"];

  connect() {
    this.updateIcons();
    this.loadModeFromStorage();
  }

  toggle() {
    const darkModeEnabled = this.isDarkModeEnabled();
    localStorage.setItem("darkMode", !darkModeEnabled);
    document.documentElement.classList.toggle('dark', !darkModeEnabled);
    this.updateIcons();
  }

  updateIcons() {
    const darkModeEnabled = this.isDarkModeEnabled();
    this.iconTargets.forEach(icon => {
      icon.style.display = icon.dataset.icon === (darkModeEnabled ? 'moon' : 'sun') ? 'block' : 'none';
    });
  }

  isDarkModeEnabled() {
    return localStorage.getItem("darkMode") === "true";
  }

  loadModeFromStorage() {
    const darkModeEnabled = this.isDarkModeEnabled();
    document.documentElement.classList.toggle('dark', darkModeEnabled);
  }
}
