import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "menu"]

  connect() {
    this.handleResize = this.handleResize.bind(this)
    window.addEventListener("resize", this.handleResize)
  }

  disconnect() {
    window.removeEventListener("resize", this.handleResize)
  }

  toggle() {
    if (this.isDesktop()) return

    const expanded = !this.menuTarget.classList.contains("show")
    this.setExpanded(expanded)
  }

  close() {
    if (this.isDesktop()) return

    this.setExpanded(false)
  }

  handleResize() {
    if (this.isDesktop()) {
      this.setExpanded(false)
    }
  }

  setExpanded(expanded) {
    this.menuTarget.classList.toggle("show", expanded)
    this.buttonTarget.setAttribute("aria-expanded", expanded ? "true" : "false")
  }

  isDesktop() {
    return window.matchMedia("(min-width: 992px)").matches
  }
}
