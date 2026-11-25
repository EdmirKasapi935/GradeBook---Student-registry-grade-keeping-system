import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "row"]

  filter() {
    const selected = this.selectTarget.value
    this.rowTargets.forEach((row) => {
      row.hidden = selected !== "" && row.dataset.semester !== selected
    })
  }
}
