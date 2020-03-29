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
  selectedShop: null,
  method: null
};

const onClickCancel = (state, action, draft) => {
  draft.status = 'idle';
  draft.prevShops = initialState.prevShops;
  draft.shops = state.prevShops || initialState.shops;
  draft.selectedShop = initialState.selectedShop;
};

const onClickSave = (state, action, draft) => {
  const methods = {
    creating: 'POST',
    editing: 'PUT',
    deleting: 'DELETE'
  };
  draft.method = methods[state.status];
  draft.status = 'saving';
  const shop = draft.shops[state.selectedShop];
  Object.assign(shop, action.payload);
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
    case 'clickEdit': {
      draft.status = 'editing';
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
      let fields = {};
      if (Object.keys(state.shops).length > 0) {
        const first = Object.values(state.shops)[0];
        fields = Object.keys(first).reduce((acc, next) => {
          if (next === 'id') {
            return acc;
          }
          return { ...acc, [next]: '' };
        }, {});
      }
      draft.shops[temporaryId] = {
        ...fields,
        temporaryId,
        latitude: latlng.lat,
        longitude: latlng.lng
      };
      draft.selectedShop = temporaryId;
      return draft;
    }
    case 'clickSave': {
      return onClickSave(state, action, draft);
    }
    case 'clickCancel': {
      return onClickCancel(state, action, draft);
    }
  }
}

function deletingStatus(state, action, draft) {
  switch (action.type) {
    case 'clickMarker': {
      draft.selectedShop = getMarkerId(action.payload);
      return draft;
    }
    case 'clickSave': {
      return onClickSave(state, action, draft);
    }
    case 'clickCancel': {
      draft.selectedShop = state.selectedShop;
      return onClickCancel(state, action, draft);
    }
  }
}

function editingStatus(state, action, draft) {
  switch (action.type) {
    case 'clickSave': {
      return onClickSave(state, action, draft);
    }
    case 'clickCancel': {
      draft.selectedShop = state.selectedShop;
      return onClickCancel(state, action, draft);
    }
  }
}

function savingStatus(state, action, draft) {
  switch (action.type) {
    case 'saveSuccessful': {
      const shop = action.payload;
      delete draft.shops[state.selectedShop];
      draft.shops[shop.id] = shop;
      draft.selectedShop = shop.id;
      draft.status = 'idle';
      return draft;
    }
    case 'saveFailed': {
      const statuses = {
        POST: 'creating',
        PUT: 'editing',
        DELETE: 'deleting'
      };
      draft.status = statuses[state.method];
      draft.method = initialState.method;
    }
  }
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

    if (state.status === 'saving') {
      savingStatus(state, action, draft);
    }
  });

export default reducer;
