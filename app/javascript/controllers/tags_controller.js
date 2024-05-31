// app/javascript/controllers/tags_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "tags", "tagsInput", "dropdownTag", "container"];

  connect() {
    this.tags = [];

    const tagsData = this.tagsInputTarget.value;
    if (tagsData) {
      this.tags = [...new Set(tagsData.split(",").map(tag => tag.trim()))];
      this.renderTags();
    }
  }

  addTag(event) {
    if (event.key === "Enter" && this.inputTarget.value.trim() !== "") {
      event.preventDefault();
      const tagText = this.inputTarget.value.trim();
      if (!this.tags.includes(tagText)) {
        this.tags.push(tagText);
        this.renderTags();
        this.updateTagInputs();
      }
      this.inputTarget.value = "";
    }
  }

  toggleTag(event) {
    const checkbox = event.target;
    const tagText = checkbox.value;

    if (checkbox.checked && !this.tags.includes(tagText)) {
      this.tags.push(tagText);
    } else {
      this.tags = this.tags.filter(tag => tag !== tagText);
    }
    this.renderTags();
    this.updateTagInputs();
  }

  removeTag(event) {
    const tagText = event.target.closest("span").dataset.tag;
    this.tags = this.tags.filter(tag => tag !== tagText);

    const checkbox = this.dropdownTagTargets.find(
      checkbox => checkbox.value === tagText
    );
    if (checkbox) {
      checkbox.checked = false;
    }

    this.renderTags();
    this.updateTagInputs();
  }

  renderTags() {
    this.tagsTarget.innerHTML = this.tags
      .map(
        tag => `
        <span id="badge-dismiss-dark" class="inline-flex items-center px-2 py-1 me-2 text-sm font-medium text-gray-800 bg-gray-100 rounded dark:bg-gray-700 dark:text-gray-300" data-tag="${tag}">
          ${tag}
          <button type="button" class="inline-flex items-center p-1 ms-2 text-sm text-gray-400 bg-transparent rounded-sm hover:bg-gray-200 hover:text-gray-900 dark:hover:bg-gray-600 dark:hover:text-gray-300" data-action="click->tags#removeTag">
            <svg class="w-2 h-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
              <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
            </svg>
            <span class="sr-only">Remove badge</span>
          </button>
        </span>
      `
      )
      .join("");
  }

  updateTagInputs() {
    const tagInputsContainer = document.createElement("div");
    this.tags.forEach(tag => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = "tags[]";
      input.value = tag;
      tagInputsContainer.appendChild(input);
    });
    this.element.querySelector("div.tag-inputs").innerHTML = tagInputsContainer.innerHTML;
  }
}
