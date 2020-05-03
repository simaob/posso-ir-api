import produce from 'immer';
import { initialState, deletingStatus } from './reducer';
import {
  mockShop,
  shouldChangeBounds,
  shouldUpdateShopAndSave,
  shouldUpdateWithFetchedShops
} from './test-utils';

jest.mock('uuid', () => ({
  v4: jest.fn(() => 'random')
}));

const reducer = (s, a) => produce(s, d => deletingStatus(s, a, d));

describe('MapView -> Reducer -> Deleting Status', () => {
  const state = {
    ...initialState,
    status: 'deleting',
    shops: {
      [mockShop.id]: mockShop,
      2: { id: 2 }
    }
  };

  it('clickMarker: should update selectedShopId; if select is deleted, should change status to idle', () => {
    const action = { type: 'clickMarker', payload: { id: mockShop.id } };
    const _state = {
      ...state,
      shops: {
        ...state.shops,
        [mockShop.id]: {
          ...mockShop,
          state: 'marked_for_deletion'
        }
      }
    };

    const newState = reducer(_state, action);
    expect(newState).toEqual({
      ..._state,
      selectedShopId: mockShop.id,
      status: 'idle'
    });
  });

  it('clickSave: should update the selected shop values, set the method to post, set status to saving', () => {
    const _state = {
      ...state,
      selectedShopId: mockShop.id
    };

    shouldUpdateShopAndSave(_state, reducer, expect, 'DELETE');
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
