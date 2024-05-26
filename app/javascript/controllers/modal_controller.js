import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modalContent"];

  connect() {
    console.log("connected");
  }

  close(event) {
    // Check if the click is outside the modal content or on the close button
    if (
      !this.modalContentTarget.contains(event.target) ||
      event.target.matches('button[data-action="click->modal#close"]')
    ) {
      this.element.classList.add("hidden");
      setTimeout(() => {
        // Retrieve the resource ID from the modal element's data attribute
        const resourceId = this.element.getAttribute("data-resource-id");
        // Define regex patterns for paths with dynamic IDs
        const redirectPatterns = {
          "/users/edit": `/profile/${resourceId}`,
          "^/dashboard/topics/\\d+/edit$": "/dashboard",
          "/dashboard/topics/new": "/dashboard",
          "^/dashboard/tags/\\d+/edit$": "/dashboard",
          "/dashboard/tags/new": "/dashboard",
        };

        // Get the current pathname
        let currentPath = window.location.pathname;

        // Check if the current path matches any of the patterns
        let redirectPath = null;
        for (let pattern in redirectPatterns) {
          const regex = new RegExp(pattern);
          if (regex.test(currentPath)) {
            redirectPath = redirectPatterns[pattern];
            break;
          }
        }

        // Redirect to the matched path or default to "/"
        if (redirectPath) {
          window.location.href = redirectPath;
        } else {
          window.location.href = "/";
        }
      }, 100); // Adjust the delay time as needed
    }
  }
}
