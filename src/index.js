import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import me from './data/me.json';
import jobs from './data/jobs.json';

Elm.Main.init({
  node: document.getElementById('root'),
  flags: { me, jobs }
});

registerServiceWorker();
