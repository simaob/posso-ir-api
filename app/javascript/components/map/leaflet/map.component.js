import React from 'react';
// import L from 'leaflet';
// import MapComponent, { MapControls, ZoomControl } from 'vizzuality-components/dist/map';
// import marker from 'leaflet/dist/images/marker-icon.png';
// import marker2x from 'leaflet/dist/images/marker-icon-2x.png';
// import markerShadow from 'leaflet/dist/images/marker-shadow.png';
import Markers from './markers.component';

// import 'vizzuality-components/dist/map.css';
// import 'leaflet/dist/leaflet.css';

// stupid hack so that leaflet's images work after going through webpack
// https://github.com/PaulLeCam/react-leaflet/issues/255
// delete L.Icon.Default.prototype._getIconUrl;
// L.Icon.Default.mergeOptions({
//   iconRetinaUrl: marker2x,
//   iconUrl: marker,
//   shadowUrl: markerShadow
// });

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

function LeafletMap(props) {
  const { dispatch, shops } = props;
  const events = {
    click: e => dispatch({ type: 'clickMap', payload: e })
  };

  return (
    <MapComponent mapOptions={mapOptions} basemap={BASEMAP} events={events}>
      {map => (
        <>
          <MapControls>
            <ZoomControl map={map} />
          </MapControls>
          <Markers
            map={map}
            data={Object.values(shops)}
            onClick={e => dispatch({ type: 'clickMarker', payload: e })}
          />
        </>
      )}
    </MapComponent>
  );
}

export default React.memo(LeafletMap);
