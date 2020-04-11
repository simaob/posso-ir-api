import React, { useMemo } from 'react';
import { LayerManager, Layer } from 'layer-manager/dist/components';
import { PluginMapboxGl } from 'layer-manager';
import BasicMap from './basic-map';
import * as Layers from './layers';

const initialViewport = {
  latitude: 39.65,
  longitude: -4.57,
  zoom: 5
};

function MapboxMap(props) {
  const { shops = {}, dispatch } = props;
  const layers = useMemo(() => {
    const _layers = [];
    if (process.env.NODE_ENV === 'development') {
      _layers.push(Layers.devBasemapLayer());
    }
    const shopsGeoJson = {
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
    _layers.push(Layers.shopsLayer(shopsGeoJson));

    return _layers;
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
      mapboxApiAccessToken={process.env.MAPBOX_TOKEN}
      mapStyle={process.env.NODE_ENV !== 'development' ? process.env.MAPBOX_STYLE : undefined}
      minZoom={2}
      interactiveLayerIds={['shops-clusters', 'shops']}
      onClick={onClick}
      initialViewport={initialViewport}
    >
      {map => (
        <LayerManager map={map} plugin={PluginMapboxGl}>
          {layers.map(l => (
            <Layer key={l.id} {...l} />
          ))}
        </LayerManager>
      )}
    </BasicMap>
  );
}

export default React.memo(MapboxMap);
