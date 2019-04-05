export default class Utils {
  static animateCSS(element, animationName, callback) {
    element.classList.add('animated', animationName)

    let handleAnimationEnd = () => {
      element.classList.remove('animated', animationName)
      element.removeEventListener('animationend', handleAnimationEnd)
      if (typeof callback == 'function') {
        callback()
      }
    }

    element.addEventListener('animationend', handleAnimationEnd)
  }
}
