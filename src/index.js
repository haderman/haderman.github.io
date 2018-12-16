import './main.scss';
import me from './data/me.json';
import jobs from './data/jobs.json';
import { Elm } from './elm.js';
import registerServiceWorker from './registerServiceWorker';

Elm.Main.init({
  node: document.getElementById('root'),
  flags: { me, jobs }
});

registerServiceWorker();
