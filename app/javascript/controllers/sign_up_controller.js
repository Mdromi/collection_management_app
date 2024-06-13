import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Fetch sign-up URL from data attribute
    const signUpUrl = this.data.get("url");

    if (signUpUrl) {
      // Open the sign-up URL in a new tab
      this.openSignUpUrl(signUpUrl);
    }
  }

  openSignUpUrl(url) {
    // Open URL in a new tab
    const newTab = window.open(url, '_blank');
    
    // Check if newTab is null (pop-up blocked or other issue)
    if (!newTab) {
      console.error('Failed to open sign-up URL in a new tab');
    }
  }
}
