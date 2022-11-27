import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

export default class extends Controller {
  static values = {
    url: String
  }

  connect() {
    this.element.addEventListener("change", () => {
      this.validate()
    })
  }

  async validate() {
    if (this.urlValue) {
      let data = new FormData()
      data.append(this.element.name, this.element.value)

      const response = await post(this.urlValue, {
        body: data
      })

      if (response.ok) {
        const json = await response.json
        const errors = json['errors']

        if (errors && errors.length) {
          this.element.setCustomValidity(errors[0])
        } else {
          this.element.setCustomValidity('')
        }

        this.element.reportValidity()
      }
    }
  }
}
