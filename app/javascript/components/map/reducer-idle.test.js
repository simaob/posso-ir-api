import produce from 'immer';
import { initialState, idleStatus } from './reducer';
import { shouldChangeBounds, shouldUpdateWithFetchedShops } from './test-utils';

const reducer = (s, a) => produce(s, d => idleStatus(s, a, d));

describe('MapView -> Reducer -> Idle Status', () => {
  const state = {
    ...initialState,
    status: 'idle',
    shops: {
      1: { id: 1 },
      2: { id: 2 },
      tempOne: { temporaryId: 'tempOne' }
    }
  };

  it('clickAdd: should change status to creating and update prevShops', () => {
    const action = { type: 'clickAdd' };
    const newState = reducer(state, action);
    expect(newState).toEqual({
      ...state,
      status: 'creating',
      prevShops: state.shops
    });
  });

  it('clickDelete: should change status to deleting and update prevShops', () => {
    const action = { type: 'clickDelete' };
    const newState = reducer(state, action);
    expect(newState).toEqual({
      ...state,
      status: 'deleting',
      prevShops: state.shops
    });
  });

  it('clickEdit: should change status to editing and update prevShops', () => {
    const action = { type: 'clickEdit' };
    const newState = reducer(state, action);
    expect(newState).toEqual({
      ...state,
      status: 'editing',
      prevShops: state.shops
    });
  });

  it('clickMarker: toggle selectedShopId', () => {
    const markerOneClicked = { type: 'clickMarker', payload: { id: 1 } };
    const markerTwoClicked = { type: 'clickMarker', payload: { id: 2 } };

    const newState = reducer(state, markerOneClicked);
    expect(newState).toEqual({
      ...state,
      selectedShopId: markerOneClicked.payload.id
    });

    const newState2 = reducer(newState, markerTwoClicked);
    expect(newState2).toEqual({
      ...state,
      selectedShopId: markerTwoClicked.payload.id
    });

    const newState3 = reducer(newState2, markerTwoClicked);
    expect(newState3).toEqual({
      ...state,
      selectedShopId: initialState.selectedShopId
    });
  });

  it('clickCloseSidebar: should reset selectedShopId', () => {
    const _state = { ...state, selectedShopId: 2 };
    const action = { type: 'clickCloseSidebar' };
    const newState = reducer(_state, action);
    expect(newState).toEqual({ ..._state, selectedShopId: initialState.selectedShopId });
  });

  it('boundsChange: should update bounds', () => {
    shouldChangeBounds(state, reducer, expect);
  });

  it('shopsFetched: should update with fetched shops', () => {
    shouldUpdateWithFetchedShops(state, reducer, expect);
  });
});
