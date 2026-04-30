import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle"]

  toggle() {
    const collapsed = this.element.classList.toggle("admin-shell--collapsed")

    if (!this.hasToggleTarget) return

    this.toggleTarget.setAttribute("aria-pressed", collapsed ? "true" : "false")
    this.toggleTarget.setAttribute("aria-label", collapsed ? "Expandir menu lateral" : "Retrair menu lateral")
  }
}
