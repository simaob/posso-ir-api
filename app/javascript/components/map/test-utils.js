export const mockShop = {
  id: 1,
  name: 'One',
  group: 'GroupOne',
  street: 'where the streets have no name',
  city: 'Madrid',
  district: null,
  country: 'ES',
  zip_code: null,
  latitude: 40.4390525818,
  longitude: -3.6338353157,
  capacity: null,
  details: null,
  store_type: 'supermarket',
  created_at: '2020-03-24T20:31:46.702Z',
  updated_at: '2020-03-24T20:31:46.702Z',
  lonlat: 'POINT (-3.6338353157 40.4390525818)',
  state: 'waiting_approval',
  reason_to_delete: null,
  open: true,
  created_by_id: null,
  updated_by_id: null,
  from_osm: false,
  original_id: null,
  source: null
};
export const emptyShop = {
  name: '',
  group: '',
  street: '',
  city: '',
  district: '',
  country: '',
  zip_code: '',
  capacity: '',
  details: '',
  store_type: '',
  created_at: '',
  updated_at: '',
  lonlat: '',
  state: '',
  reason_to_delete: '',
  open: '',
  created_by_id: '',
  updated_by_id: '',
  from_osm: '',
  original_id: '',
  source: ''
};

export const shouldChangeBounds = (state, reducer, expect) => {
  const action = { type: 'boundsChange', payload: [[1], [2]] };
  const newState = reducer(state, action);
  expect(newState).toEqual({ ...state, bounds: action.payload });
};

export const shouldUpdateWithFetchedShops = (state, reducer, expect) => {
  const action = { type: 'shopsFetched', payload: { 4: { id: 4 }, 10: { id: 10 } } };
  const newState = reducer(state, action);
  expect(newState).toEqual({
    ...state,
    shops: {
      ...action.payload,
      tempOne: state.shops.tempOne
    }
  });
};

export const shouldUpdateLngLatOnDrag = (state, reducer, expect) => {
  const action = {
    type: 'dragMarker',
    payload: [40.53741109070671, 3.6244098303195567]
  };
  const newState = reducer(state, action);
  expect(newState).toEqual({
    ...state,
    shops: {
      ...state.shops,
      [state.selectedShopId]: {
        ...state.shops[state.selectedShopId],
        longitude: action.payload[0],
        latitude: action.payload[1]
      }
    }
  });
};

export const shouldUpdateShopAndSave = (state, reducer, expect, method) => {
  const action = {
    type: 'clickSave',
    payload: {
      name: 'my new name',
      street: 'my new street',
      country: 'PT',
      city: 'Porto'
    }
  };

  const newState = reducer(state, action);
  expect(newState).toEqual({
    ...state,
    status: 'saving',
    method,
    shops: {
      ...state.shops,
      [mockShop.id]: {
        ...mockShop,
        ...action.payload
      }
    }
  });
};
