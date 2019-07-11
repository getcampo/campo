import { Controller } from "stimulus"
import Current from '../current'

export default class extends Controller {
  connect() {
    if (this.data.get('to')) {
      let roles = this.data.get('to').split(' ')

      if (roles.includes('admin')) {
        if (Current.isAdmin()) {
          console.log('admin pass')
          return
        }
      }

      if (roles.includes('creator')) {
        let creatorElement = this.element.closest('[data-creator-id]')
        if (creatorElement && creatorElement.dataset.creatorId == Current.userId()) {
          console.log('creator pass')
          return
        }
      }

      if (roles.includes('user')) {
        if (Current.userId()) {
          console.log('user pass')
          return
        }
      }
    }

    this.element.remove()
  }
}
