import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [ 'source', 'trigger' ]
  copy(event) {
    event.preventDefault()
    this.sourceTarget.select()
    document.execCommand('copy')
    this.triggerTarget.classList.remove('btn-info')
    this.triggerTarget.classList.add('btn-success')
    const that = this
    setInterval(function() {
      that.triggerTarget.classList.add('btn-info')
      that.triggerTarget.classList.remove('btn-success')
    }, 5000)
  }
}
