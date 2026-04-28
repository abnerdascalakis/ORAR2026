import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "step",
    "indicator",
    "progressBar",
    "stepLabel",
    "errorSummary",
    "field",
    "modalidadeField",
    "modalidadeError"
  ]

  static values = {
    initialStep: Number,
    stepCount: Number
  }

  connect() {
    this.currentStep = this.hasInitialStepValue ? this.initialStepValue : 0
    this.updateUI()
  }

  nextStep() {
    if (!this.validateCurrentStep()) return

    this.currentStep = Math.min(this.currentStep + 1, this.stepCountValue - 1)
    this.updateUI()
  }

  previousStep() {
    this.hideErrorSummary()
    this.currentStep = Math.max(this.currentStep - 1, 0)
    this.updateUI()
  }

  goToStep(event) {
    const targetStep = Number(event.currentTarget.dataset.stepIndex)

    if (targetStep > this.currentStep && !this.validateCurrentStep()) return

    this.hideErrorSummary()
    this.currentStep = targetStep
    this.updateUI()
  }

  submitForm(event) {
    if (!this.validateCurrentStep()) {
      event.preventDefault()
    }
  }

  validateCurrentStep() {
    if (this.currentStep === 0) {
      const fieldsAreValid = this.fieldTargets.every((field) => {
        const isValid = field.checkValidity()
        field.classList.toggle("is-invalid", !isValid)
        return isValid
      })

      this.toggleErrorSummary(!fieldsAreValid)
      return fieldsAreValid
    }

    const hasModalidade = this.modalidadeFieldTargets.some((field) => field.checked)
    this.modalidadeErrorTarget.classList.toggle("d-none", hasModalidade)
    this.toggleErrorSummary(!hasModalidade)
    return hasModalidade
  }

  updateUI() {
    this.stepTargets.forEach((step, index) => {
      const isActive = index === this.currentStep
      step.hidden = !isActive
      step.classList.toggle("is-active", isActive)
    })

    this.indicatorTargets.forEach((indicator, index) => {
      indicator.classList.toggle("is-active", index === this.currentStep)
      indicator.classList.toggle("is-complete", index < this.currentStep)
    })

    const progress = ((this.currentStep + 1) / this.stepCountValue) * 100
    this.progressBarTarget.style.width = `${progress}%`
    this.stepLabelTarget.textContent = `Etapa ${this.currentStep + 1} de ${this.stepCountValue}`
  }

  toggleErrorSummary(visible) {
    this.errorSummaryTarget.classList.toggle("d-none", !visible)
  }

  hideErrorSummary() {
    this.toggleErrorSummary(false)
  }
}
