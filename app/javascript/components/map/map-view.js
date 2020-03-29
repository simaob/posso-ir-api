import React, { useReducer, useEffect } from 'react';
import pickBy from 'lodash/pickBy';
import WRIIcons from 'vizzuality-components/dist/icons';
import reducer, { initialState } from './reducer';
import ShopsMap from './shops-map.component';
import Toolbar from './toolbar.component';
import Sidebar from './sidebar.component';

import './map-view.scss';

function saveShop(shop, method) {
  const url = method === 'POST' ? '/map' : `/map/${shop.id}`;
  const token = document.querySelector('meta[name="csrf-token"]').content;
  const trimBody = (value, key) => !!value && key !== 'temporaryId';
  const body = JSON.stringify(pickBy(shop, trimBody));
  return fetch(url, {
    body,
    method,
    headers: { 'X-CSRF-Token': token, 'Content-Type': 'application/json' }
  }).then(res => res.json());
}

function MapView(props) {
  const { shops } = props;
  const [state, dispatch] = useReducer(reducer, { ...initialState, shops });

  useEffect(() => {
    if (state.status === 'saving') {
      const shop = state.shops[state.selectedShop];
      saveShop(shop, state.method)
        .then(data => dispatch({ type: 'saveSuccessful', payload: data }))
        .catch(error => {
          dispatch({ type: 'saveFailed' });
          console.error(error);
          alert('Failed to save, something went wrong. Check the console.');
        });
    }
  });
  return (
    <div className="c-map-view">
      <WRIIcons />
      <Toolbar status={state.status} dispatch={dispatch} />
      <Sidebar status={state.status} shop={state.shops[state.selectedShop]} dispatch={dispatch} />
      <ShopsMap shops={state.shops} dispatch={dispatch} />
    </div>
  );
}

export default MapView;
