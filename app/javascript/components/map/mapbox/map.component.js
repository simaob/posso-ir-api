import React, { useMemo, useState, useCallback } from 'react';
import { Marker } from 'react-map-gl';
import { LayerManager, Layer } from 'layer-manager/dist/components';
import { PluginMapboxGl } from 'layer-manager';
import cx from 'classnames';
import BasicMap from './basic-map';
import { shopsLayer, devBasemapLayer } from './layers';

const initialViewport = {
  latitude: 39.65,
  longitude: -4.57,
  zoom: 6,
  minZoom: 6
};

const MapContent = React.memo(props => {
  const { map, layers, selectedShop, setDragging, onMarkerDragEnd, dragging } = props;
  return (
    <>
      <LayerManager map={map} plugin={PluginMapboxGl}>
        {layers.map(l => (
          <Layer key={l.id} {...l} />
        ))}
      </LayerManager>
      {selectedShop && (
        <Marker
          latitude={selectedShop.latitude}
          longitude={selectedShop.longitude}
          draggable={['editing', 'creating'].includes(status)}
          onDragStart={() => setDragging(true)}
          onDragEnd={onMarkerDragEnd}
        >
          <div className={cx('selected-shop-marker', { '-dragging': dragging })} />
        </Marker>
      )}
    </>
  );
});

function MapboxMap(props) {
  const { shops = {}, dispatch, selectedShopId, bounds = [], onBoundsChange } = props;
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

  const onClick = useCallback(
    e => {
      const shopsMarker = e.features.find(f => f.source === 'shops');
      if (shopsMarker) {
        dispatch({ type: 'clickMarker', payload: shopsMarker });
      } else {
        dispatch({ type: 'clickMap', payload: { lngLat: e.lngLat } });
      }
    },
    [dispatch]
  );

  const onMarkerDragEnd = useCallback(
    e => {
      setDragging(false);
      dispatch({ type: 'dragMarker', payload: e.lngLat });
    },
    [setDragging, dispatch]
  );

  const mapBounds = useMemo(() => ({ bbox: bounds.flat() }), [bounds]);

  return (
    <BasicMap
      bounds={mapBounds}
      mapboxApiAccessToken={process.env.MAPBOX_TOKEN}
      mapStyle={process.env.NODE_ENV !== 'development' ? process.env.MAPBOX_STYLE : undefined}
      minZoom={2}
      interactiveLayerIds={['shops']}
      onClick={onClick}
      initialViewport={initialViewport}
      onBoundsChange={onBoundsChange}
    >
      {map => (
        <MapContent
          map={map}
          layers={layers}
          dragging={dragging}
          setDragging={setDragging}
          onMarkerDragEnd={onMarkerDragEnd}
          selectedShop={selectedShopId && shops[selectedShopId]}
        />
      )}
    </BasicMap>
  );
}

export default React.memo(MapboxMap);
