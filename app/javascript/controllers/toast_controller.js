// app/javascript/controllers/toast_controller.js

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.classList.remove("hidden");
    this.timeout = setTimeout(() => {
      this.element.classList.add("hidden");
    }, 5000); // Auto-hide after 5 seconds

    this.closeButton = this.element.querySelector(".close-toast");
    this.closeButton.addEventListener("click", () => this.hide());
  }

  hide() {
    clearTimeout(this.timeout);
    this.element.classList.add("hidden");
  }
}
