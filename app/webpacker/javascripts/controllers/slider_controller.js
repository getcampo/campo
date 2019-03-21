import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['scrollbar', 'handle', 'value', 'range']

  connect() {
    this.handleTarget.addEventListener('mousedown', this.start.bind(this))

    this.handlers = {
      move: this.move.bind(this),
      stop: this.stop.bind(this)
    }

    let handleHeight = 100 / this.getRange()
    if (handleHeight < 20) {
      handleHeight = 20
    }
    this.handleTarget.style.height = `${handleHeight}%`

    this.updateHandleInfo(this.getValue(), this.getRange())
  }

  updateHandlePosition() {
    let max = this.scrollbarTarget.offsetHeight - this.handleTarget.offsetHeight
    let halfStep = max / ((this.getRange() - 1) * 2)
    let position;

    if (this.getValue() == 1) {
      position = 0
    } else if (this.getValue() == this.getRange()) {
      position = max
    } else {
      position = this.getValue() * (halfStep * 2) - halfStep
    }
    this.handleTarget.style.top = `${position}px`
  }

  updateHandleInfo(value, range) {
    this.valueTarget.textContent = value
    this.rangeTarget.textContent = range
  }

  setValue(value) {
    this.data.set('value', value)
    this.updateHandleInfo(value, this.getRange())
  }

  getValue() {
    return parseInt(this.data.get('value')) || 1
  }

  setRange(range) {
    this.data.set('range', range)
  }

  getRange() {
    return parseInt(this.data.get('range')) || 1
  }

  start(event) {
    console.log('start')
    console.log(event)
    document.addEventListener('mousemove', this.handlers.move)
    document.addEventListener('mouseup', this.handlers.stop)
    this.tmpValue = this.getValue()
  }

  move(event) {
    console.log('move')
    console.log(event)

    let scrollbarTop = this.scrollbarTarget.offsetTop
    let handleHeight = this.handleTarget.offsetHeight
    let max = this.scrollbarTarget.offsetHeight - this.handleTarget.offsetHeight
    let mouseTop = event.y
    let position = mouseTop - scrollbarTop - (handleHeight / 2)

    if (position < 0) {
      position = 0
    }

    if (position > max) {
      position = max
    }

    this.handleTarget.style.top = `${position}px`

    let halfStep = max / ((this.getRange() - 1) * 2)
    if (position < halfStep) {
      this.tmpValue = 1
    } else if (position > (max - halfStep)) {
      this.tmpValue = this.getRange()
    } else {
      this.tmpValue = Math.ceil((position + halfStep) / (halfStep * 2))
    }
    this.updateHandleInfo(this.tmpValue, this.getRange())
  }

  stop(event) {
    console.log('stop')
    console.log(event)
    document.removeEventListener('mousemove', this.handlers.move)
    document.removeEventListener('mouseup', this.handlers.stop)
    this.setValue(this.tmpValue)
  }
}
