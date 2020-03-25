import React, { useReducer, useEffect } from 'react';
import produce from 'immer';
import L from 'leaflet';
import MapComponent, { MapControls, ZoomControl } from 'vizzuality-components/dist/map';
import WRIIcons from 'vizzuality-components/dist/icons';
import marker from 'leaflet/dist/images/marker-icon.png';
import marker2x from 'leaflet/dist/images/marker-icon-2x.png';
import markerShadow from 'leaflet/dist/images/marker-shadow.png';

import 'vizzuality-components/dist/map.css';
import 'leaflet/dist/leaflet.css';
import './map-view.scss';

// stupid hack so that leaflet's images work after going through webpack
// https://github.com/PaulLeCam/react-leaflet/issues/255
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: marker2x,
  iconUrl: marker,
  shadowUrl: markerShadow
});

const BASEMAP = {
  id: 'streets',
  title: 'Streets (OSM)',
  url: '//{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
  attribution:
    '&copy;<a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, <a href="http://hot.openstreetmap.org/" target="_blank">Humanitarian OpenStreetMap Team</a>',
  thumbnail: '/images/maps/thumb-basemap-streets.png'
};

const mapOptions = {
  zoom: 6,
  center: { lat: 39.74, lng: -724.02 }
};

const initialState = {
  status: 'idle',
  shops: {},
  prevShops: null
};

function MapView() {
  const [state, dispatch] = useReducer(
    (state, action) =>
      produce(state, draft => {
        if (state.status === 'idle') {
          switch (action.type) {
            case 'clickAdd': {
              draft.status = 'adding';
              draft.prevShops = state.shops;
              return draft;
            }
            case 'clickDelete': {
              draft.status = 'deleting';
              draft.prevShops = state.shops;
              return draft;
            }
          }
        }

        if (state.status === 'adding') {
          switch (action.type) {
            case 'clickMap': {
              const { latlng } = action.payload;
              const temporaryId = `${latlng.lat}_${latlng.lng}`;
              draft.shops[temporaryId] = {
                latlng,
                temporaryId
              };
              return draft;
            }
          }
        }

        if (state.status === 'deleting') {
          switch (action.type) {
            case 'clickCancel': {
              draft.status = 'idle';
              draft.prevShops = initialState.prevShops;
              draft.shops = state.prevShops || initialState.shops;
              return draft;
            }
            case 'clickMarker': {
              const {
                target: {
                  options: { temporaryId }
                }
              } = action.payload;
              delete draft.shops[temporaryId];
              return draft;
            }
          }
        }

        if (state.status !== 'idle') {
          switch (action.type) {
            case 'clickCancel': {
              draft.status = 'idle';
              draft.prevShops = initialState.prevShops;
              draft.shops = state.prevShops || initialState.shops;
              return draft;
            }
            case 'clickSave': {
              draft.status = 'idle';
              draft.prevShops = initialState.prevShops;
              return draft;
            }
          }
        }
      }),
    initialState
  );
  const events = {
    click: e => dispatch({ type: 'clickMap', payload: e })
  };
  return (
    <div className="c-map-view">
      <Toolbar status={state.status} dispatch={dispatch} />
      <WRIIcons />
      <MapComponent mapOptions={mapOptions} basemap={BASEMAP} events={events}>
        {map => (
          <>
            <MapControls>
              <ZoomControl map={map} />
            </MapControls>
            {Object.values(state.shops).map((shop, i) => (
              <Marker
                map={map}
                key={shop.temporaryId + i}
                latlng={shop.latlng}
                name={shop.temporaryId}
                temporaryId={shop.temporaryId}
                onClick={e => dispatch({ type: 'clickMarker', payload: e })}
              />
            ))}
          </>
        )}
      </MapComponent>
    </div>
  );
}

function Marker(props) {
  const { latlng, name, map, temporaryId, onClick } = props;
  useEffect(() => {
    const marker = L.marker(latlng, { title: name, temporaryId });
    marker.on('click', onClick);
    marker.addTo(map);
    return () => {
      marker.off();
      marker.remove();
    };
  }, [latlng, name, map]);

  return null;
}

function Toolbar(props) {
  const { status, dispatch } = props;
  const dispatchAction = e => {
    const { actionType } = e.target.dataset;
    dispatch({ type: actionType });
  };
  return (
    <div className="c-toolbar">
      <div className="d-flex justify-content-end">
        {status === 'idle' && (
          <>
            <button
              type="button"
              className="btn btn-outline-primary mr-2"
              onClick={dispatchAction}
              data-action-type="clickAdd"
            >
              Add stores
            </button>
            <button
              type="button"
              className="btn btn-outline-danger"
              onClick={dispatchAction}
              data-action-type="clickDelete"
            >
              Delete stores
            </button>
          </>
        )}
        {status !== 'idle' && (
          <>
            <button
              type="button"
              className="btn btn-outline-secondary mr-2"
              onClick={dispatchAction}
              data-action-type="clickCancel"
            >
              Cancel
            </button>
            <button
              type="button"
              className="btn btn-outline-success"
              onClick={dispatchAction}
              data-action-type="clickSave"
            >
              Save
            </button>
          </>
        )}
      </div>
    </div>
  );
}

export default MapView;
