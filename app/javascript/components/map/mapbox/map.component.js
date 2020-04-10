import React, { useMemo } from 'react';
import { LayerManager, Layer } from 'layer-manager/dist/components';
import { PluginMapboxGl } from 'layer-manager';
import BasicMap from './basic-map';
import { shopsLayer } from './layers';

const initialViewport = {
  latitude: 39.65,
  longitude: -4.57,
  zoom: 5
};

function MapboxMap(props) {
  const { shops = {}, dispatch } = props;
  const layer = useMemo(() => {
    const collection = {
      type: 'FeatureCollection',
      features: Object.values(shops).map(shop => ({
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [shop.longitude, shop.latitude]
        },
        properties: shop
      }))
    };

    return shopsLayer(collection);
  }, [shops]);

  const onClick = e => {
    const shopsMarker = e.features.find(f => f.source === 'shops');
    if (shopsMarker) {
      dispatch({ type: 'clickMarker', payload: shopsMarker });
    } else {
      dispatch({ type: 'clickMap', payload: { lngLat: e.lngLat } });
    }
  };

  return (
    <BasicMap
      mapboxApiAccessToken="pk.eyJ1IjoicG9zc29pciIsImEiOiJjazh1aG90MzgwNmV4M2ZwODg1emlzcDhwIn0.oj2w7Ri9H3WRoZUQwgR3DQ"
      mapStyle="mapbox://styles/possoir/ck8uiswqg0k3k1ipb3sgurmqm"
      minZoom={2}
      viewport={initialViewport}
      interactiveLayerIds={['shops-clusters', 'shops']}
      onClick={onClick}
    >
      {map => (
        <LayerManager map={map} plugin={PluginMapboxGl}>
          {[layer].map(l => (
            <Layer key={l.id} {...l} />
          ))}
        </LayerManager>
      )}
    </BasicMap>
  );
}

export default React.memo(MapboxMap);
