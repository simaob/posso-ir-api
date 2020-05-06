import produce from 'immer';
import { initialState, creatingStatus } from './reducer';
import { v4 as uuidv4 } from 'uuid';
import {
  mockShop,
  emptyShop,
  shouldChangeBounds,
  shouldUpdateShopAndSave,
  shouldUpdateLngLatOnDrag,
  shouldUpdateWithFetchedShops
} from './test-utils';

jest.mock('uuid', () => ({
  v4: jest.fn(() => 'random')
}));

const reducer = (s, a) => produce(s, d => creatingStatus(s, a, d));

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
    const _state = { ...state, selectedShopId: mockShop.id };
    shouldUpdateLngLatOnDrag(_state, reducer, expect);
  });

  it('clickSave: should update the selected shop values, set the method to PUT, set status to saving', () => {
    const _state = {
      ...state,
      selectedShopId: mockShop.id
    };

    shouldUpdateShopAndSave(_state, reducer, expect, 'POST');
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
