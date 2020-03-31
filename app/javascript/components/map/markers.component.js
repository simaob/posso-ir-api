import React, { useEffect } from 'react';
import 'leaflet.markercluster';

import 'leaflet.markercluster/dist/MarkerCluster.css';
import 'leaflet.markercluster/dist/MarkerCluster.Default.css';

function Markers(props) {
  const { data, onClick, map } = props;
  useEffect(() => {
    const clusterGroup = L.markerClusterGroup({ zoomToBoundsOnClick: true });
    const onMarkerClick = onClick;
    const createdMarkers = [];
    const markersToCluster = [];

    data.forEach(shop => {
      const { latitude, longitude, name, id, temporaryId } = shop;
      const marker = L.marker(L.latLng(latitude, longitude), {
        title: name,
        id: id || temporaryId
      });

      if (typeof id === 'undefined') {
        marker.on('click', onMarkerClick);
        map.addLayer(marker);
        createdMarkers.push(marker);
      } else {
        markersToCluster.push(marker);
      }
    });
    clusterGroup.addLayers(markersToCluster);
    clusterGroup.on('click', onMarkerClick);
    map.addLayer(clusterGroup);
    return () => {
      clusterGroup.off('click', onMarkerClick);
      clusterGroup.clearLayers();
      createdMarkers.forEach(marker => {
        marker.off('click', onMarkerClick);
        marker.remove();
      });
    };
  }, [data, map]);

  return null;
}

export default React.memo(Markers);
