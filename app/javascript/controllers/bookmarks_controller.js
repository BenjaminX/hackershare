import { Controller } from 'stimulus';
import { format, render, cancel, register } from 'timeago.js';

export default class extends Controller {
  static targets = ['input', 'list'];

  append(event) {
    const [data, status, xhr] = event.detail;
    if (RegExp('^Turbolinks').test(xhr.response)){
      return
    }
    this.listTarget.innerHTML = xhr.response + this.listTarget.innerHTML;
    const timeagos = document.querySelectorAll('.timeago');
    const lang = I18n.locale == 'zh-CN' ? 'zh_CN' : 'en_US'
    render(timeagos, lang);

    this.inputTarget.value = '';
  }
}