import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [ 'source', 'trigger' ]
  copy(event) {
    this.sourceTarget.select()
    document.execCommand('copy')
    this.triggerTarget.classList.remove('btn-primary')
    this.triggerTarget.classList.add('btn-success')
    const that = this
    setInterval(function() {
      that.triggerTarget.classList.add('btn-primary')
      that.triggerTarget.classList.remove('btn-success')
    }, 5000)
  }
}
