import { useEffect } from 'react';
import pickBy from 'lodash/pickBy';
import axios, { CancelToken } from 'axios';

const defaultHeaders = {
  'Content-Type': 'application/json',
  Accept: 'application/json'
};

function saveShop(shop, method) {
  const url = method === 'POST' ? '/map' : `/map/${shop.id}`;
  const token = document.querySelector('meta[name="csrf-token"]').content;
  const trimBody = (value, key) => !!value && key !== 'temporaryId';
  const data = pickBy(shop, trimBody);
  const source = CancelToken.source();
  const request = axios(url, {
    data,
    method,
    headers: {
      'X-CSRF-Token': token,
      ...defaultHeaders
    }
  }).then(res => res.data);

  return { source, request };
}

export function useSaveShop(state, dispatch) {
  useEffect(() => {
    let requestSource;
    if (state.status === 'saving') {
      const shop = state.shops[state.selectedShopId];
      const { source, request } = saveShop(shop, state.method);
      requestSource = source;
      request
        .then(data => dispatch({ type: 'saveSuccessful', payload: data }))
        .catch(error => {
          dispatch({ type: 'saveFailed' });
          console.error(error);
          alert('Failed to save, something went wrong. Check the console.');
        });
    }

    return () => {
      if (requestSource) {
        requestSource.cancel();
      }
    };
  });
}

function fetchShops(bounds) {
  const url = '/map.json';
  const token = document.querySelector('meta[name="csrf-token"]').content;
  const source = CancelToken.source();
  const request = axios(url, {
    params: { coordinates: bounds.map(b => b.join(',')) },
    headers: {
      'X-CSRF-Token': token,
      ...defaultHeaders
    },
    cancelToken: source.token
  }).then(res => res.data);

  return { source, request };
}

export function useFetchShops(state, dispatch) {
  useEffect(() => {
    let requestSource = null;
    if (state.bounds) {
      const { source, request } = fetchShops(state.bounds);
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
}
