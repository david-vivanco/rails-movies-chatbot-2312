import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "title", "poster", "closeLink"]

  open(event) {
    const title = event.currentTarget.dataset.title
    const poster = event.currentTarget.dataset.poster

    this.titleTarget.textContent = title
    this.posterTarget.src = poster

    const url = new URL(this.closeLinkTarget.href)
    url.searchParams.set("selected_movie", title)

    this.closeLinkTarget.href = url.toString()

    this.modalTarget.classList.remove("d-none")
  }

  close() {
  this.modalTarget.classList.add("d-none")
  }
}
