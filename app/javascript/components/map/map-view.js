import React, { useReducer, useEffect, useMemo } from 'react';
import produce from 'immer';
import L from 'leaflet';
import 'leaflet.markercluster';
import MapComponent, { MapControls, ZoomControl } from 'vizzuality-components/dist/map';
import WRIIcons from 'vizzuality-components/dist/icons';
import marker from 'leaflet/dist/images/marker-icon.png';
import marker2x from 'leaflet/dist/images/marker-icon-2x.png';
import markerShadow from 'leaflet/dist/images/marker-shadow.png';

import 'vizzuality-components/dist/map.css';
import 'leaflet/dist/leaflet.css';
import 'leaflet.markercluster/dist/MarkerCluster.css';
import 'leaflet.markercluster/dist/MarkerCluster.Default.css';
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
  center: { lat: 39.74, lng: -3.71 }
};

const initialState = {
  status: 'idle',
  shops: {},
  prevShops: null,
  selectedShop: null
};

const getInitialState = (apiShops = []) => {
  const shops = apiShops.reduce((acc, shop) => ({ ...acc, [shop.id]: shop }), {});
  return {
    ...initialState,
    shops
  };
};

function MapView(props) {
  const { shops } = props;
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
            case 'clickMarker': {
              const {
                target: {
                  options: { id }
                }
              } = action.payload;
              draft.selectedShop = id === state.selectedShop ? initialState.selectedShop : id;
              return draft;
            }
            case 'clickCloseSidebar': {
              draft.selectedShop = initialState.selectedShop;
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
                latitude: latlng.lat,
                longitude: latlng.lng,
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
                  options: { id }
                }
              } = action.payload;
              delete draft.shops[id];
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
    getInitialState(shops)
  );
  const cluster = useMarkerCluster(state.shops);
  const events = {
    click: e => dispatch({ type: 'clickMap', payload: e })
  };
  return (
    <div className="c-map-view">
      <WRIIcons />
      <Toolbar status={state.status} dispatch={dispatch} />
      <Sidebar shop={state.shops[state.selectedShop]} dispatch={dispatch} />
      <MapComponent mapOptions={mapOptions} basemap={BASEMAP} events={events}>
        {map => (
          <>
            <MapControls>
              <ZoomControl map={map} />
            </MapControls>
            {Object.values(state.shops).map(shop => (
              <Marker
                map={map}
                cluster={cluster}
                key={shop.id || shop.temporaryId}
                latitude={shop.latitude}
                longitude={shop.longitude}
                name={shop.name}
                id={shop.id || shop.temporaryId}
                onClick={e => dispatch({ type: 'clickMarker', payload: e })}
              />
            ))}
          </>
        )}
      </MapComponent>
    </div>
  );
}

function useMarkerCluster(markers) {
  return useMemo(() => L.markerClusterGroup({ zoomToBoundsOnClick: true }), [markers]);
}

function Marker(props) {
  const { latitude, longitude, name, map, id, onClick, cluster } = props;
  useEffect(() => {
    const marker = L.marker(L.latLng(latitude, longitude), {
      title: name,
      id
    });
    marker.on('click', onClick);
    cluster.addLayer(marker);
    map.addLayer(cluster);
    return () => {
      cluster.removeLayer(marker);
      marker.off();
      marker.remove();
      cluster.remove();
    };
  }, [latitude, longitude, name, map]);

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

function Sidebar(props) {
  const { shop, dispatch } = props;
  return (
    <aside className={`c-sidebar ${shop ? '-visible' : ''}`}>
      {shop && (
        <div className="header">
          <p>{shop.name || `${shop.latitude.toFixed(3)}, ${shop.longitude.toFixed(3)}`}</p>
          <button
            type="button"
            className="close-button"
            aria-label="Close"
            onClick={() => dispatch({ type: 'clickCloseSidebar' })}
          >
            close
          </button>
        </div>
      )}
    </aside>
  );
}

export default MapView;
