import produce from 'immer';
import { initialState, editingStatus } from './reducer';
import {
  mockShop,
  shouldChangeBounds,
  shouldUpdateShopAndSave,
  shouldUpdateWithFetchedShops,
  shouldUpdateLngLatOnDrag
} from './test-utils';

jest.mock('uuid', () => ({
  v4: jest.fn(() => 'random')
}));

const reducer = (s, a) => produce(s, d => editingStatus(s, a, d));

describe('MapView -> Reducer -> Editing Status', () => {
  const state = {
    ...initialState,
    status: 'editing',
    shops: {
      [mockShop.id]: mockShop,
      2: { id: 2 }
    }
  };

  it('dragMarker: should update the selected shop latitude and longitude', () => {
    const _state = { ...state, selectedShopId: mockShop.id };
    shouldUpdateLngLatOnDrag(_state, reducer, expect);
  });

  it('clickSave: should update the selected shop values, set the method to post, set status to saving', () => {
    const _state = {
      ...state,
      selectedShopId: mockShop.id
    };

    shouldUpdateShopAndSave(_state, reducer, expect, 'PUT');
  });

  it('clickCancel: should set status to idle, restore shops from prevShops, and reset prevShops', () => {
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
