import React, { useReducer, useRef } from 'react';
import reducer, { initialState } from './reducer';
import Toolbar from './toolbar.component';
import Sidebar from './sidebar.component';
import ShopsMap from './mapbox/map.component';
import isEqual from 'lodash/isEqual';
import debounce from 'lodash/debounce';
import { useFetchShops, useSaveShop } from './api-effects';

import './map-view.scss';

function MapView(props) {
  const { shops, fields, labels, initialBounds } = props;
  const [state, dispatch] = useReducer(reducer, { ...initialState, shops });
  const setBounds = useRef(
    debounce(bounds => dispatch({ type: 'boundsChange', payload: bounds })),
    2500
  );

  useFetchShops(state, dispatch);
  useSaveShop(state, dispatch);

  const onBoundsChange = (bounds, viewport) => {
    const prevBounds = (state.bounds || initialBounds || []).flat().map(b => b.toFixed(3));
    const nextBounds = bounds.flat().map(b => b.toFixed(3));
    if (!isEqual(nextBounds, prevBounds) && viewport.zoom >= 10) {
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
