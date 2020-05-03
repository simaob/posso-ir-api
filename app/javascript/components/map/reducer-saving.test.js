import produce from 'immer';
import { initialState, savingStatus } from './reducer';
import {
  mockShop,
  shouldChangeBounds,
  shouldUpdateShopAndSave,
  shouldUpdateWithFetchedShops
} from './test-utils';

jest.mock('uuid', () => ({
  v4: jest.fn(() => 'random')
}));

const reducer = (s, a) => produce(s, d => savingStatus(s, a, d));

describe('MapView -> Reducer -> Saving Status', () => {
  const state = {
    ...initialState,
    status: 'deleting',
    shops: {
      [mockShop.id]: mockShop,
      2: { id: 2 }
    }
  };

  it('saveSuccessful: should replace selected shop with the incoming payload and change status to idle', () => {
    const action = {
      type: 'saveSuccessful',
      payload: {
        ...mockShop,
        updated_at: Date.now(),
        state: 'marked_for_deletion'
      }
    };

    const _state = {
      ...state,
      selectedShopId: mockShop.id
    };

    const newState = reducer(_state, action);
    expect(newState).toEqual({
      ..._state,
      status: 'idle',
      shops: {
        ..._state.shops,
        [mockShop.id]: action.payload
      }
    });
  });

  it('saveFailed: should revert to previous status and reset method', () => {
    const action = { type: 'saveFailed' };
    const previouslyCreating = {
      ...state,
      method: 'POST'
    };
    expect(reducer(previouslyCreating, action)).toEqual({
      ...previouslyCreating,
      status: 'creating',
      method: initialState.method
    });

    const previouslyEditing = {
      ...state,
      method: 'PUT'
    };
    expect(reducer(previouslyEditing, action)).toEqual({
      ...previouslyEditing,
      status: 'editing',
      method: initialState.method
    });

    const previouslyDeleting = {
      ...state,
      method: 'DELETE'
    };
    expect(reducer(previouslyDeleting, action)).toEqual({
      ...previouslyDeleting,
      status: 'deleting',
      method: initialState.method
    });
  });

  it('boundsChange: should update the bounds', () => {
    shouldChangeBounds(state, reducer, expect);
  });

  it('shopsFetched: should update with fetched shops', () => {
    shouldUpdateWithFetchedShops(state, reducer, expect);
  });
});
