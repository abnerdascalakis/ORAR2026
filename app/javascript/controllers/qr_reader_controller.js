import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "mealWrapper", "operation", "token", "video", "warning"]

  connect() {
    this.syncOperation()
    this.scanning = false
  }

  disconnect() {
    this.stopCamera()
  }

  syncOperation() {
    const alimentacao = this.operationTarget.value === "alimentacao"
    this.mealWrapperTarget.classList.toggle("d-none", !alimentacao)
  }

  async toggleCamera() {
    if (this.scanning) {
      this.stopCamera()
      return
    }

    if (!("BarcodeDetector" in window)) {
      this.showWarning("Este navegador nao tem leitor de QR nativo. Cole o token no campo.")
      return
    }

    try {
      this.detector = new BarcodeDetector({ formats: ["qr_code"] })
      this.stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } })
      this.videoTarget.srcObject = this.stream
      this.videoTarget.classList.remove("d-none")
      await this.videoTarget.play()
      this.scanning = true
      this.scan()
    } catch (_error) {
      this.showWarning("Nao foi possivel acessar a camera. Cole o token no campo.")
    }
  }

  async scan() {
    if (!this.scanning) return

    const codes = await this.detector.detect(this.videoTarget)

    if (codes.length > 0) {
      this.tokenTarget.value = codes[0].rawValue
      this.stopCamera()
      this.formTarget.requestSubmit()
      return
    }

    requestAnimationFrame(() => this.scan())
  }

  stopCamera() {
    this.scanning = false
    this.videoTarget.classList.add("d-none")
    this.stream?.getTracks().forEach((track) => track.stop())
    this.stream = null
  }

  showWarning(message) {
    this.warningTarget.textContent = message
    this.warningTarget.classList.remove("d-none")
  }
}
