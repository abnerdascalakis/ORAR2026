import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["search", "input", "menu", "option", "empty"]

  connect() {
    this.handleOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.handleOutsideClick)
    this.filter()
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick)
  }

  filter() {
    const query = this.normalize(this.searchTarget.value)
    let visibleCount = 0
    const selectedOption = this.optionTargets.find((option) => option.dataset.distritoId === this.inputTarget.value)

    if (selectedOption && this.searchTarget.value !== selectedOption.dataset.distritoName) {
      this.inputTarget.value = ""
    }

    this.optionTargets.forEach((option) => {
      const matches = this.normalize(option.dataset.distritoName).includes(query)
      option.classList.toggle("d-none", !matches)
      if (matches) visibleCount += 1
    })

    this.emptyTarget.classList.toggle("d-none", visibleCount > 0)
  }

  show() {
    this.menuTarget.classList.remove("d-none")
    this.dispatch("opened")
    this.filter()
  }

  hide() {
    this.menuTarget.classList.add("d-none")
  }

  select(event) {
    const option = event.currentTarget
    this.inputTarget.value = option.dataset.distritoId
    this.searchTarget.value = option.dataset.distritoName
    this.menuTarget.classList.add("d-none")
    this.dispatch("selected", { detail: { id: option.dataset.distritoId } })
  }

  clear() {
    this.inputTarget.value = ""
    this.searchTarget.value = ""
    this.menuTarget.classList.remove("d-none")
    this.filter()
    this.searchTarget.focus()
    this.dispatch("cleared")
  }

  normalize(value) {
    return value
      .toString()
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase()
      .trim()
  }

  handleOutsideClick(event) {
    if (this.element.contains(event.target)) return

    this.hide()
  }
}
