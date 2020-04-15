import React, { useMemo, useState } from 'react';
import { Marker } from 'react-map-gl';
import { LayerManager, Layer } from 'layer-manager/dist/components';
import { PluginMapboxGl } from 'layer-manager';
import cx from 'classnames';
import BasicMap from './basic-map';
import { shopsLayer, devBasemapLayer } from './layers';

const initialViewport = {
  latitude: 39.65,
  longitude: -4.57,
  zoom: 5
};

function MapboxMap(props) {
  const { shops = {}, dispatch, selectedShopId, status } = props;
  const [dragging, setDragging] = useState(false);
  const layers = useMemo(() => {
    const _layers = [];
    if (process.env.NODE_ENV === 'development') {
      _layers.push(devBasemapLayer());
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
    _layers.push(shopsLayer(shopsGeoJson, selectedShopId));

    return _layers;
  }, [shops, selectedShopId]);

  const onClick = e => {
    const shopsMarker = e.features.find(f => f.source === 'shops');
    if (shopsMarker) {
      dispatch({ type: 'clickMarker', payload: shopsMarker });
    } else {
      dispatch({ type: 'clickMap', payload: { lngLat: e.lngLat } });
    }
  };

  const onMarkerDragEnd = e => {
    setDragging(false);
    dispatch({ type: 'dragMarker', payload: e.lngLat });
  };

  return (
    <BasicMap
      mapboxApiAccessToken={process.env.MAPBOX_TOKEN}
      mapStyle={process.env.NODE_ENV !== 'development' ? process.env.MAPBOX_STYLE : undefined}
      minZoom={2}
      interactiveLayerIds={['shops']}
      onClick={onClick}
      initialViewport={initialViewport}
    >
      {map => (
        <>
          <LayerManager map={map} plugin={PluginMapboxGl}>
            {layers.map(l => (
              <Layer key={l.id} {...l} />
            ))}
          </LayerManager>
          {selectedShopId && (
            <Marker
              latitude={shops[selectedShopId].latitude}
              longitude={shops[selectedShopId].longitude}
              draggable={['editing', 'creating'].includes(status)}
              onDragStart={() => setDragging(true)}
              onDragEnd={onMarkerDragEnd}
            >
              <div className={cx('selected-shop-marker', { '-dragging': dragging })} />
            </Marker>
          )}
        </>
      )}
    </BasicMap>
  );
}

export default React.memo(MapboxMap);
