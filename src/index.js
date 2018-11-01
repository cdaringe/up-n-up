import './main.css'
import { Elm } from './Main.elm'
import steps from './steps.json'

const app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: { steps }
})

app.ports.scrollIdIntoView.subscribe(function (domId) {
  var target = document.getElementById(domId)
  if (!target) {
    return console.error(`no target named: ${domId}`)
  }
  window.history.pushState(null, null, `#${domId}`)
  target.scrollIntoView({
    behavior: 'smooth'
  })
})
