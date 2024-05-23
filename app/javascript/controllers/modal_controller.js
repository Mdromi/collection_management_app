// app/javascript/controllers/modal_controller.js

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modalContent"];

  connect() {
  }

  close(event) {
    // Check if the click is outside the modal content or on the close button
    if (!this.modalContentTarget.contains(event.target) || event.target.closest('button[data-action="click->modal#close"]')) {
      this.element.classList.add("hidden");
      setTimeout(() => {
        window.location.href = '/'; // Redirect to root path after a brief delay
      }, 300); // Adjust the delay time as needed
    }
  }
}
