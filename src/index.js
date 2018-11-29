import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import me from './json/me.json';

console.log('ME -> ', me);

Elm.Main.init({
  node: document.getElementById('root'),
  flags: { me }
});

registerServiceWorker();
