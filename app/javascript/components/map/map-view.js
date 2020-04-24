import React, { useReducer, useEffect, useRef } from 'react';
import pickBy from 'lodash/pickBy';
import reducer, { initialState } from './reducer';
import Toolbar from './toolbar.component';
import Sidebar from './sidebar.component';
import ShopsMap from './mapbox/map.component';
import axios, { CancelToken } from 'axios';
import isEqual from 'lodash/isEqual';
import debounce from 'lodash/debounce';

import './map-view.scss';

function saveShop(shop, method) {
  const url = method === 'POST' ? '/map' : `/map/${shop.id}`;
  const token = document.querySelector('meta[name="csrf-token"]').content;
  const trimBody = (value, key) => !!value && key !== 'temporaryId';
  const data = pickBy(shop, trimBody);
  return axios(url, {
    data,
    method,
    headers: { 'X-CSRF-Token': token, 'Content-Type': 'application/json' }
  }).then(res => res.data);
}

function fetchMarkers(bounds) {
  const url = '/map.json';
  const token = document.querySelector('meta[name="csrf-token"]').content;
  const source = CancelToken.source();
  const request = axios(url, {
    params: { coordinates: bounds.map(b => b.join(',')) },
    headers: { 'X-CSRF-Token': token, 'Content-Type': 'application/json' },
    cancelToken: source.token
  }).then(res => res.data);

  return { request, source };
}

function MapView(props) {
  const { shops, fields, labels, initialBounds } = props;
  const [state, dispatch] = useReducer(reducer, { ...initialState, shops });
  const setBounds = useRef(
    debounce(bounds => dispatch({ type: 'boundsChange', payload: bounds })),
    2500
  );

  useEffect(() => {
    if (state.status === 'saving') {
      const shop = state.shops[state.selectedShopId];
      saveShop(shop, state.method)
        .then(data => dispatch({ type: 'saveSuccessful', payload: data }))
        .catch(error => {
          dispatch({ type: 'saveFailed' });
          console.error(error);
          alert('Failed to save, something went wrong. Check the console.');
        });
    }
  });

  useEffect(() => {
    let requestSource = null;
    if (state.bounds) {
      const { source, request } = fetchMarkers(state.bounds);
      requestSource = source;
      request
        .then(payload => dispatch({ type: 'shopsFetched', payload }))
        .catch(err => !axios.isCancel(err) && console.error(err));
    }

    return () => {
      if (requestSource) {
        requestSource.cancel();
      }
    };
  }, [state.bounds]);

  const onBoundsChange = bounds => {
    const prevBounds = (state.bounds || initialBounds || []).flat().map(b => b.toFixed(3));
    const nextBounds = bounds.flat().map(b => b.toFixed(3));
    if (!isEqual(nextBounds, prevBounds)) {
      setBounds.current(bounds);
    }
  };

  return (
    <div className="c-map-view">
      <Toolbar status={state.status} dispatch={dispatch} labels={labels} />
      <Sidebar
        status={state.status}
        shop={state.shops[state.selectedShopId]}
        fields={fields}
        dispatch={dispatch}
        labels={labels}
      />
      <ShopsMap
        bounds={state.bounds || initialBounds || null}
        shops={state.shops}
        dispatch={dispatch}
        onBoundsChange={onBoundsChange}
        selectedShopId={state.selectedShopId}
        status={state.status}
      />
    </div>
  );
}

export default MapView;
