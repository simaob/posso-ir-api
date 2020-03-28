import React, { useReducer } from 'react';
import WRIIcons from 'vizzuality-components/dist/icons';
import reducer, { initialState } from './reducer';
import ShopsMap from './shops-map.component';
import Toolbar from './toolbar.component';
import Sidebar from './sidebar.component';

import './map-view.scss';

function MapView(props) {
  const { shops } = props;
  const [state, dispatch] = useReducer(reducer, { ...initialState, shops });
  return (
    <div className="c-map-view">
      <WRIIcons />
      <Toolbar status={state.status} dispatch={dispatch} />
      <Sidebar shop={state.shops[state.selectedShop]} dispatch={dispatch} />
      <ShopsMap shops={state.shops} dispatch={dispatch} />
    </div>
  );
}

export default MapView;
