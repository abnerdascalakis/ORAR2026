import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "step",
    "indicator",
    "progressBar",
    "stepLabel",
    "errorSummary",
    "successMessage",
    "field",
    "form",
    "modalidadeField",
    "modalidadeError"
  ]

  static values = {
    stepCount: Number
  }

  connect() {
    this.currentStep = 0
    this.refresh()
  }

  nextStep() {
    if (!this.validateStep(this.currentStep)) return

    this.currentStep = Math.min(this.currentStep + 1, this.stepCountValue - 1)
    this.refresh()
  }

  previousStep() {
    this.currentStep = Math.max(this.currentStep - 1, 0)
    this.hideFeedback()
    this.refresh()
  }

  goToStep(event) {
    const nextIndex = Number(event.currentTarget.dataset.stepIndex)

    if (nextIndex > this.currentStep && !this.validateStep(this.currentStep)) return

    this.currentStep = nextIndex
    this.hideFeedback()
    this.refresh()
  }

  submitForm(event) {
    if (!this.validateStep(this.currentStep) || !this.validateModalidades()) {
      event.preventDefault()
      return
    }
  }

  refresh() {
    this.stepTargets.forEach((step, index) => {
      const active = index === this.currentStep
      step.hidden = !active
      step.classList.toggle("is-active", active)
    })

    this.indicatorTargets.forEach((indicator, index) => {
      indicator.classList.toggle("is-active", index === this.currentStep)
      indicator.classList.toggle("is-complete", index < this.currentStep)
    })

    const progress = ((this.currentStep + 1) / this.stepCountValue) * 100
    this.progressBarTarget.style.width = `${progress}%`
    this.progressBarTarget.parentElement.setAttribute("aria-valuenow", progress)
    this.stepLabelTarget.textContent = `Etapa ${this.currentStep + 1} de ${this.stepCountValue}`
  }

  validateStep(stepIndex) {
    this.hideFeedback()

    const currentStep = this.stepTargets[stepIndex]
    const requiredFields = this.fieldTargets.filter((field) => currentStep.contains(field))
    let valid = true

    requiredFields.forEach((field) => {
      const fieldValid = field.checkValidity()
      field.classList.toggle("is-invalid", !fieldValid)
      valid = valid && fieldValid
    })

    if (stepIndex === 1) {
      valid = this.validateModalidades() && valid
    }

    if (!valid) {
      this.errorSummaryTarget.classList.remove("d-none")
    }

    return valid
  }

  validateModalidades() {
    if (!this.hasModalidadeFieldTarget) return true

    const selected = this.modalidadeFieldTargets.some((field) => field.checked)
    this.modalidadeErrorTarget.classList.toggle("d-none", selected)
    return selected
  }

  hideFeedback() {
    this.errorSummaryTarget.classList.add("d-none")
    if (this.hasSuccessMessageTarget) {
      this.successMessageTarget.classList.add("d-none")
    }
  }
}
