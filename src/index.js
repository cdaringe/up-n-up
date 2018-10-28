import './main.css'
import { Elm } from './Main.elm'
import steps from './steps.json'
// import registerServiceWorker from './registerServiceWorker'
// registerServiceWorker()
const app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: { steps }
})

app.ports.scrollIdIntoView.subscribe(function (domId) {
  document.getElementById(domId).scrollIntoView({
    behavior: 'smooth'
  })
})
