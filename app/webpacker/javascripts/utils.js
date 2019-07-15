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

  static showSnackbar(message) {
    let snackbar = `
      <div class="snackbar animated fadeInUp" data-controller="snackbar" data-hide-on="5000">
        ${message}
      </div>
    `
    document.querySelector('body').insertAdjacentHTML('beforeend', snackbar)
  }
}
