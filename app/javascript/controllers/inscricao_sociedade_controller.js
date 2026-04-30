import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["distritoInput", "sociedadeId", "sociedadeBusca", "search", "menu", "option", "empty"]

  connect() {
    this.handleOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.handleOutsideClick)
    this.filter()
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick)
  }

  filter() {
    const distritoId = this.distritoInputTarget.value
    const query = this.normalize(this.searchTarget.value)
    let visibleCount = 0
    const selectedOption = this.optionTargets.find((option) => option.dataset.sociedadeId === this.sociedadeIdTarget.value)

    if (selectedOption && this.searchTarget.value !== selectedOption.dataset.sociedadeLabel) {
      this.clear()
    }

    if (!distritoId) {
      this.optionTargets.forEach((option) => option.classList.add("d-none"))
      this.emptyTarget.textContent = "Escolha um distrito primeiro."
      this.emptyTarget.classList.remove("d-none")
      return
    }

    this.optionTargets.forEach((option) => {
      const sameDistrito = option.dataset.distritoId === distritoId
      const matchesQuery = this.normalize(option.dataset.sociedadeLabel).includes(query)
      const isVisible = sameDistrito && matchesQuery

      option.classList.toggle("d-none", !isVisible)
      if (isVisible) visibleCount += 1
    })

    this.emptyTarget.textContent = "Nenhuma sociedade encontrada."
    this.emptyTarget.classList.toggle("d-none", visibleCount > 0)
  }

  show() {
    this.menuTarget.classList.remove("d-none")
    this.filter()
  }

  hide() {
    this.menuTarget.classList.add("d-none")
  }

  select(event) {
    const option = event.currentTarget
    this.sociedadeIdTarget.value = option.dataset.sociedadeId
    this.sociedadeBuscaTarget.value = option.dataset.sociedadeLabel
    this.searchTarget.value = option.dataset.sociedadeLabel
    this.menuTarget.classList.add("d-none")
    this.searchTarget.classList.remove("is-invalid")
  }

  clear() {
    this.sociedadeIdTarget.value = ""
    this.sociedadeBuscaTarget.value = ""
    this.searchTarget.value = ""
  }

  resetForDistrito() {
    this.clear()
    this.hide()
    this.filter()
  }

  clearAndFilter() {
    this.clear()
    this.menuTarget.classList.remove("d-none")
    this.filter()
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
