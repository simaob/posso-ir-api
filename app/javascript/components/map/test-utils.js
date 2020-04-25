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
