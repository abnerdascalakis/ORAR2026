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
    this.updateUI({ scroll: true })
  }

  previousStep() {
    this.hideErrorSummary()
    this.currentStep = Math.max(this.currentStep - 1, 0)
    this.updateUI({ scroll: true })
  }

  goToStep(event) {
    const targetStep = Number(event.currentTarget.dataset.stepIndex)

    if (targetStep > this.currentStep && !this.validateUntil(targetStep)) return

    this.hideErrorSummary()
    this.currentStep = targetStep
    this.updateUI({ scroll: true })
  }

  submitForm(event) {
    if (!this.validateCurrentStep()) {
      event.preventDefault()
    }
  }

  formatTelefone(event) {
    const digits = event.target.value.replace(/\D/g, "").slice(0, 11)
    const ddd = digits.slice(0, 2)
    const prefix = digits.slice(2, 7)
    const suffix = digits.slice(7, 11)

    if (digits.length > 7) {
      event.target.value = `(${ddd}) ${prefix}-${suffix}`
    } else if (digits.length > 2) {
      event.target.value = `(${ddd}) ${prefix}`
    } else if (digits.length > 0) {
      event.target.value = `(${ddd}`
    } else {
      event.target.value = ""
    }
  }

  validateCurrentStep() {
    return this.validateStep(this.currentStep)
  }

  validateUntil(targetStep) {
    for (let step = this.currentStep; step < targetStep; step += 1) {
      if (!this.validateStep(step)) {
        this.currentStep = step
        this.updateUI({ scroll: true })
        return false
      }
    }

    return true
  }

  validateStep(step) {
    if (step === 0) {
      const fieldsAreValid = this.fieldTargets.every((field) => {
        const isValid = field.checkValidity()
        field.classList.toggle("is-invalid", !isValid)
        return isValid
      })

      this.toggleErrorSummary(!fieldsAreValid)
      return fieldsAreValid
    }

    if (step > 1) {
      this.hideErrorSummary()
      return true
    }

    const hasModalidade = this.modalidadeFieldTargets.some((field) => field.checked)
    if (this.hasModalidadeErrorTarget) {
      this.modalidadeErrorTarget.classList.toggle("d-none", hasModalidade)
    }

    this.toggleErrorSummary(!hasModalidade)
    return hasModalidade
  }

  updateUI(options = {}) {
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

    if (options.scroll) {
      this.scrollToFormTop()
    }
  }

  scrollToFormTop() {
    if (!window.matchMedia("(max-width: 991.98px)").matches) return

    window.requestAnimationFrame(() => {
      const navbarHeight = this.navbarHeight()
      const top = this.element.getBoundingClientRect().top + window.scrollY - navbarHeight - 16
      const behavior = window.matchMedia("(prefers-reduced-motion: reduce)").matches ? "auto" : "smooth"

      window.scrollTo({
        top: Math.max(top, 0),
        behavior
      })
    })
  }

  navbarHeight() {
    const cssHeight = Number.parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--orar-navbar-height"))
    if (Number.isFinite(cssHeight)) return cssHeight

    return document.querySelector(".orar-navbar")?.offsetHeight || 0
  }

  toggleErrorSummary(visible) {
    this.errorSummaryTarget.classList.toggle("d-none", !visible)
  }

  hideErrorSummary() {
    this.toggleErrorSummary(false)
  }
}
