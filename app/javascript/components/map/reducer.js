import produce from 'immer';
import { v4 as uuidv4 } from 'uuid';

const getMarkerId = payload => {
  const { layer, target } = payload;

  if (layer) {
    return layer.options.id;
  }
  return target.options.id;
};

export const initialState = {
  status: 'idle',
  shops: {},
  prevShops: null,
  selectedShop: null
};

function idleStatus(state, action, draft) {
  switch (action.type) {
    case 'clickAdd': {
      draft.status = 'creating';
      draft.prevShops = state.shops;
      return draft;
    }
    case 'clickDelete': {
      draft.status = 'deleting';
      draft.prevShops = state.shops;
      return draft;
    }
    case 'clickMarker': {
      const id = getMarkerId(action.payload);
      draft.selectedShop = id === state.selectedShop ? initialState.selectedShop : id;
      return draft;
    }
    case 'clickCloseSidebar': {
      draft.selectedShop = initialState.selectedShop;
      return draft;
    }
  }
}

function creatingStatus(state, action, draft) {
  switch (action.type) {
    case 'clickMap': {
      const { latlng } = action.payload;
      if (state.selectedShop) {
        delete draft.shops[state.selectedShop];
      }
      const temporaryId = uuidv4();
      draft.shops[temporaryId] = {
        latitude: latlng.lat,
        longitude: latlng.lng,
        temporaryId
      };
      draft.selectedShop = temporaryId;
      return draft;
    }
  }
}

function deletingStatus(state, action, draft) {
  switch (action.type) {
    case 'clickCancel': {
      draft.status = 'idle';
      draft.prevShops = initialState.prevShops;
      draft.shops = state.prevShops || initialState.shops;
      return draft;
    }
    case 'clickMarker': {
      draft.selectedShop = getMarkerId(action.payload);
      return draft;
    }
  }
}

function editingStatus(state, action, draft) {
  return draft;
}

const reducer = (state = initialState, action) =>
  produce(state, draft => {
    if (state.status === 'idle') {
      idleStatus(state, action, draft);
    }

    if (state.status === 'creating') {
      creatingStatus(state, action, draft);
    }

    if (state.status === 'deleting') {
      deletingStatus(state, action, draft);
    }

    if (state.status === 'editing') {
      editingStatus(state, action, draft);
    }

    if (state.status !== 'idle') {
      switch (action.type) {
        case 'clickCancel': {
          draft.status = 'idle';
          draft.prevShops = initialState.prevShops;
          draft.shops = state.prevShops || initialState.shops;
          draft.selectedShop = initialState.selectedShop;
          return draft;
        }
        case 'clickSave': {
          draft.status = 'idle';
          draft.prevShops = initialState.prevShops;
          return draft;
        }
      }
    }
  });

export default reducer;
