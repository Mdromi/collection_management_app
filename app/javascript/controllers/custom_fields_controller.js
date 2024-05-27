// app/javascript/controllers/custom_fields_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fieldsContainer", "template"];

  addField(event) {
    event.preventDefault();
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime());
    this.fieldsContainerTarget.insertAdjacentHTML('beforeend', content);
  }

  removeField(event) {
    event.preventDefault();
    const field = event.target.closest(".custom-field");
    field.remove();
  }
}
