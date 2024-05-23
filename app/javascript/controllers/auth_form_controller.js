// app/javascript/controllers/auth_form_controller.js
import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = ['email', 'password', 'form'];

  validateForm() {
    const email = this.emailTarget.value.trim();
    const password = this.passwordTarget.value.trim();

    if (email === '' || password === '') {
      this.formTarget.querySelector('input[type="submit"]').disabled = true;
    } else {
      this.formTarget.querySelector('input[type="submit"]').disabled = false;
    }
  }
}
