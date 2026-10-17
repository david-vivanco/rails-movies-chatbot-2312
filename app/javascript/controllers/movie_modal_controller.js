import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "title", "poster"]

  open(event) {
  this.titleTarget.textContent = event.currentTarget.dataset.title
  this.posterTarget.src = event.currentTarget.dataset.poster

  this.modalTarget.classList.remove("d-none")
  }

  close() {
  this.modalTarget.classList.add("d-none")
  }
}
