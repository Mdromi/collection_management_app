import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.showSpinner();
  }

  showSpinner() {
    document.addEventListener("turbo:submit-start", () => {
      this.show();
    });

    document.addEventListener("turbo:submit-end", () => {
      this.hide();
    });
  }

  show() {
    document.getElementById("spinner-container").classList.remove("hidden");
  }

  hide() {
    document.getElementById("spinner-container").classList.add("hidden");
  }
}
