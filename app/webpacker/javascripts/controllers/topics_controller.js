import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['composer']

  newTopic() {
    this.composerTarget.composerController.open()
  }
}
