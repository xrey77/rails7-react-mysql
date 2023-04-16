import { createRoot } from 'react-dom/client';

import * as React from "react";
import { HashRouter } from 'react-router-dom';
import Xrouters from './router';
  

const root = createRoot(document.getElementById('root'));
root.render(
  <HashRouter>
    <Xrouters />
  </HashRouter>
);
