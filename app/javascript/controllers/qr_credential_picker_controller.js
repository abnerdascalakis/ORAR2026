import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "districtSearch",
    "personName",
    "option",
    "checkbox",
    "empty",
    "count",
    "districtSubmit",
    "personSubmit",
    "selectAll"
  ]

  connect() {
    this.filterDistricts()
    this.update()
  }

  filterDistricts() {
    const query = this.normalize(this.districtSearchTarget.value)
    let visibleCount = 0

    this.optionTargets.forEach((option) => {
      const matches = this.normalize(option.dataset.districtName).includes(query)
      option.classList.toggle("d-none", !matches)
      if (matches) visibleCount += 1
    })

    this.emptyTarget.classList.toggle("d-none", visibleCount > 0)
  }

  toggleAllDistricts() {
    this.checkboxTargets.forEach((checkbox) => {
      checkbox.checked = this.selectAllTarget.checked
    })
    this.update()
  }

  update() {
    const selectedCount = this.checkboxTargets.filter((checkbox) => checkbox.checked).length
    const hasPersonName = this.personNameTarget.value.trim().length > 0
    this.selectAllTarget.checked = selectedCount === this.checkboxTargets.length

    this.countTargets.forEach((count) => {
      count.textContent = this.districtCountLabel(selectedCount)
    })

    this.districtSubmitTarget.disabled = selectedCount === 0
    this.personSubmitTarget.disabled = !hasPersonName
  }

  districtCountLabel(selectedCount) {
    if (selectedCount === 0) return "0 distritos selecionados"
    if (selectedCount === 1) return "1 distrito selecionado"

    return `${selectedCount} distritos selecionados`
  }

  normalize(value) {
    return value
      .toString()
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase()
      .trim()
  }
}
