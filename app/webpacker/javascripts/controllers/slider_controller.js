import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['scrollbar', 'handle', 'value', 'range']

  connect() {
    this.element.sliderController = this
    this.scrollbarTarget.addEventListener('click', this.select.bind(this))
    this.handleTarget.addEventListener('mousedown', this.start.bind(this))
    this.handleTarget.addEventListener('touchstart', this.start.bind(this), { passive: false })

    this.handlers = {
      move: this.move.bind(this),
      stop: this.stop.bind(this)
    }

    this.update()
  }

  setData(begin, end, total) {
    this.setBegin(begin)
    this.setEnd(end)
    this.setTotal(total)
    this.update()
  }

  update() {
    let stepHeight = 100 / this.getTotal()

    let handleHeight = stepHeight * this.getLength()
    if (handleHeight < 20) {
      handleHeight = 20
    }
    this.handleTarget.style.height = `${handleHeight}%`

    let spaceHeight = 100 - handleHeight
    let spaceStepHeight;
    if (spaceHeight > 0) {
      spaceStepHeight = (100 - handleHeight) / (this.getTotal() - this.getLength())
    } else {
      spaceStepHeight = 0
    }
    let handleTop = spaceStepHeight * (this.getBegin() - 1)
    this.handleTarget.style.top = `${handleTop}%`

    this.updateHandleInfo(this.getEnd(), this.getTotal())
  }

  updateHandleInfo(end, total) {
    this.valueTarget.textContent = end
    this.rangeTarget.textContent = total
  }

  setBegin(value) {
    this.data.set('begin', value)
  }

  setEnd(value) {
    this.data.set('end', value)
  }

  setTotal(value) {
    this.data.set('total', value)
  }

  getBegin() {
    return parseInt(this.data.get('begin')) || 1
  }

  getEnd() {
    return parseInt(this.data.get('end')) || 1
  }

  getTotal() {
    return parseInt(this.data.get('total')) || 1
  }

  getLength() {
    return this.getEnd() - this.getBegin() + 1
  }

  triggerEvent() {
    this.element.dispatchEvent(
      new CustomEvent('slider.change', { detail: { begin: this.getBegin(), end: this.getEnd(), total: this.getTotal() } })
    )
  }

  start(event) {
    event.preventDefault()
    document.addEventListener('mousemove', this.handlers.move)
    document.addEventListener('mouseup', this.handlers.stop)
    document.addEventListener('touchmove', this.handlers.move, { passive: false })
    document.addEventListener('touchend', this.handlers.stop, { passive: false })
    this.tmpValue = this.getBegin()
  }

  move(event) {
    event.preventDefault()
    let scrollbarTop = this.scrollbarTarget.getBoundingClientRect().top
    let scrollbarHeight = this.scrollbarTarget.offsetHeight
    let handleHeight = this.handleTarget.offsetHeight
    let max = scrollbarHeight - handleHeight
    let mouseTop = event.clientY || event.touches[0].clientY
    let position = mouseTop - scrollbarTop - (handleHeight / 2)

    if (max == 0) {
      return
    }

    if (position < 0) {
      position = 0
    }

    if (position > max) {
      position = max
    }

    this.handleTarget.classList.add('dragging')
    this.handleTarget.style.top = `${position}px`

    let halfStep = max / (this.getTotal() - 1) / 2
    if (position < halfStep) {
      this.tmpValue = 1
    } else if (position > (max - halfStep)) {
      this.tmpValue = this.getTotal()
    } else {
      this.tmpValue = Math.ceil((position + halfStep) / (halfStep * 2))
    }
    this.updateHandleInfo(this.tmpValue, this.getTotal())
  }

  stop(event) {
    event.preventDefault()
    document.removeEventListener('mousemove', this.handlers.move)
    document.removeEventListener('mouseup', this.handlers.stop)
    document.removeEventListener('touchmove', this.handlers.move)
    document.removeEventListener('touchend', this.handlers.stop)
    this.handleTarget.classList.remove('dragging')
    this.setBegin(this.tmpValue)
    this.setEnd(this.tmpValue + this.getLength() - 1)
    this.triggerEvent()
  }

  select(event) {
    if (event.target == this.scrollbarTarget) {
      this.move(event)
      this.handleTarget.classList.remove('dragging')
      this.setBegin(this.tmpValue)
      this.setEnd(this.tmpValue + this.getLength() - 1)
      this.triggerEvent()
    }
  }

  min() {
    this.setBegin(1)
    this.setEnd(1)
    this.update()
    this.triggerEvent()
  }

  max() {
    this.setBegin(this.getTotal())
    this.setEnd(this.getTotal())
    this.update()
    this.triggerEvent()
  }
}
