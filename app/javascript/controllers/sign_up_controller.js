// app/javascript/controllers/signUpController.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Fetch sign-up URL from data attribute
    console.log("Connected");
    const signUpUrl = this.data.get("url");
    console.log("signUpUrl", signUpUrl);

    if (signUpUrl) {
      window.open(signUpUrl, '_blank');
    }
  }
}
