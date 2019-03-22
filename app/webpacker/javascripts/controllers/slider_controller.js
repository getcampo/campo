import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['scrollbar', 'handle', 'value', 'range']

  connect() {
    this.element.slider = this
    this.scrollbarTarget.addEventListener('click', this.select.bind(this))
    this.handleTarget.addEventListener('mousedown', this.start.bind(this))

    this.handlers = {
      move: this.move.bind(this),
      stop: this.stop.bind(this)
    }

    this.updateHandle()
  }

  updateHandle() {
    this.updateHandleHeight()
    this.updateHandlePosition()
    this.updateHandleInfo(this.getValue(), this.getRange())
  }

  updateHandleHeight() {
    let handleHeight = 100 / this.getRange()
    if (handleHeight < 20) {
      handleHeight = 20
    }
    this.handleTarget.style.height = `${handleHeight}%`
  }

  updateHandlePosition() {
    let max = this.scrollbarTarget.offsetHeight - this.handleTarget.offsetHeight
    let halfStep = max / ((this.getRange() - 1) * 2)
    let position;

    position = (this.getValue() - 1) * (halfStep * 2)
    this.handleTarget.style.top = `${position}px`
  }

  updateHandleInfo(value, range) {
    this.valueTarget.textContent = value
    this.rangeTarget.textContent = range
  }

  setValue(value) {
    this.data.set('value', value)
    this.updateHandlePosition()
    this.updateHandleInfo(value, this.getRange())
  }

  triggerEvent() {
    this.element.dispatchEvent(
      new CustomEvent('slider.change', {detail: { value: this.getValue(), range: this.getRange() } })
    )
  }

  getValue() {
    return parseInt(this.data.get('value')) || 1
  }

  setRange(range) {
    this.data.set('range', range)
    this.updateHandle()
  }

  getRange() {
    return parseInt(this.data.get('range')) || 1
  }

  start(event) {
    document.addEventListener('mousemove', this.handlers.move)
    document.addEventListener('mouseup', this.handlers.stop)
    this.tmpValue = this.getValue()
  }

  move(event) {
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
    document.removeEventListener('mousemove', this.handlers.move)
    document.removeEventListener('mouseup', this.handlers.stop)
    this.data.set('value', this.tmpValue)
    this.triggerEvent()
  }

  select(event) {
    if (event.target == this.scrollbarTarget) {
      this.move(event)
      this.data.set('value', this.tmpValue)
      this.triggerEvent()
    }
  }
}
