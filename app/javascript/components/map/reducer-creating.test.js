import produce from 'immer';
import { initialState, creatingStatus } from './reducer';
import { v4 as uuidv4 } from 'uuid';
import { shouldChangeBounds, shouldUpdateWithFetchedShops } from './test-utils';

jest.mock('uuid', () => ({
  v4: jest.fn(() => 'random')
}));

const reducer = (s, a) => produce(s, d => creatingStatus(s, a, d));
const mockShop = {
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
const emptyShop = {
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

describe('MapView -> Reducer -> Creating Status', () => {
  const state = {
    ...initialState,
    status: 'creating',
    shops: {
      [mockShop.id]: mockShop,
      2: { id: 2 }
    }
  };

  it('clickMap: should create a new store with a temporaryId and mark as selected', () => {
    const action = {
      type: 'clickMap',
      payload: { lngLat: [40.53741109070671, 3.6244098303195567] }
    };
    const newState = reducer(state, action);
    const temporaryId = 'random';
    expect(newState).toEqual({
      ...state,
      selectedShopId: temporaryId,
      shops: {
        ...state.shops,
        [temporaryId]: {
          ...emptyShop,
          temporaryId,
          longitude: action.payload.lngLat[0],
          latitude: action.payload.lngLat[1]
        }
      }
    });
  });

  it('clickMap: should delete the previously created shop', () => {
    const _state = {
      ...state,
      selectedShopId: 'temp',
      shops: { ...state.shops, temp: { temporaryId: 'temp' } }
    };
    const action = {
      type: 'clickMap',
      payload: { lngLat: [40.53741109070671, 3.6244098303195567] }
    };
    const newState = reducer(_state, action);
    expect(newState.shops).toEqual(expect.not.objectContaining({ temp: mockShop }));
  });

  it('dragMarker: should update the selected shop latitude and longitude', () => {
    const action = {
      type: 'dragMarker',
      payload: [40.53741109070671, 3.6244098303195567]
    };
    const _state = { ...state, selectedShopId: 1 };
    const newState = reducer(_state, action);
    expect(newState).toEqual({
      ..._state,
      shops: {
        ..._state.shops,
        1: {
          ..._state.shops[1],
          longitude: action.payload[0],
          latitude: action.payload[1]
        }
      }
    });
  });

  it('clickSave: should update the selected shop values, set the method to post, set status to saving', () => {
    const action = {
      type: 'clickSave',
      payload: {
        name: 'my new name',
        street: 'my new street',
        country: 'PT',
        city: 'Porto'
      }
    };
    const _state = {
      ...state,
      selectedShopId: 1
    };

    const newState = reducer(_state, action);
    expect(newState).toEqual({
      ..._state,
      status: 'saving',
      method: 'POST',
      shops: {
        ..._state.shops,
        1: {
          ...mockShop,
          ...action.payload
        }
      }
    });
  });

  it('clickCancel: should set status to idle, restore shops from prevShops, reset prevShops and selectedShopId', () => {
    const _state = {
      ...state,
      prevShops: state.shops,
      shops: {
        ...state.shops,
        temp: { temporaryId: 'temp' }
      },
      selectedShopId: 'temp'
    };
    const action = { type: 'clickCancel' };
    const newState = reducer(_state, action);
    expect(newState).toEqual({
      ..._state,
      status: 'idle',
      prevShops: initialState.prevShops,
      selectedShopId: initialState.selectedShopId,
      shops: _state.prevShops
    });
  });

  it('boundsChange: should update the bounds', () => {
    shouldChangeBounds(state, reducer, expect);
  });

  it('shopsFetched: should update with fetched shops', () => {
    shouldUpdateWithFetchedShops(state, reducer, expect);
  });
});
