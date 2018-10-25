import './main.css'
import { Elm } from './Main.elm'
import registerServiceWorker from './registerServiceWorker'
// registerServiceWorker()
const app = Elm.Main.init({ node: document.getElementById('root') })
app.ports.scrollIdIntoView.subscribe(function(domId) {
  document.getElementById(domId).scrollIntoView({
    behavior: 'smooth'
  })
})
