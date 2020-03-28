import { useEffect } from 'react';
import 'leaflet.markercluster';

import 'leaflet.markercluster/dist/MarkerCluster.css';
import 'leaflet.markercluster/dist/MarkerCluster.Default.css';

function Markers(props) {
  const { data, onClick, map } = props;
  useEffect(() => {
    const clusterGroup = L.markerClusterGroup({ zoomToBoundsOnClick: true });

    const markers = data.map(shop => {
      const { latitude, longitude, name, id, temporaryId } = shop;
      return L.marker(L.latLng(latitude, longitude), {
        title: name,
        id: id || temporaryId
      });
    });
    clusterGroup.addLayers(markers);
    const onMarkerClick = onClick;
    clusterGroup.on('click', onMarkerClick);
    map.addLayer(clusterGroup);
    return () => {
      clusterGroup.off('click', onMarkerClick);
      clusterGroup.clearLayers();
    };
  }, [data, map]);

  return null;
}

export default Markers;
