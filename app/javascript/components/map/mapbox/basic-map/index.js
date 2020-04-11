import React, { useRef, useCallback, useState } from 'react';
import cx from 'classnames';
import ReactMapGL from 'react-map-gl';
import { useOnLoad } from './use-on-load';

function MapboxMap(props) {
  const {
    onLoad,
    bounds,
    customClass,
    children,
    dragPan,
    dragRotate,
    scrollZoom,
    touchZoom,
    touchRotate,
    initialViewport,
    doubleClickZoom,
    ...mapboxProps
  } = props;
  const [viewport, setViewport] = useState(null);
  const mapContainer = useRef(null);
  const map = useRef(null);
  const getMap = useCallback(instance => {
    map.current = instance && instance.getMap();
  }, []);
  const [loaded, setLoaded] = useOnLoad();

  return (
    <div ref={mapContainer} className={cx('c-map', { [customClass]: !!customClass })}>
      <ReactMapGL
        ref={getMap}
        // CUSTOM PROPS FROM REACT MAPBOX API
        {...mapboxProps}
        {...initialViewport}
        {...viewport}
        width="100%"
        height="100%"
        // INTERACTIVE
        dragPan={dragPan}
        dragRotate={dragRotate}
        scrollZoom={scrollZoom}
        touchZoom={touchZoom}
        touchRotate={touchRotate}
        doubleClickZoom={doubleClickZoom}
        // DEFAULT FUNC IMPLEMENTATIONS
        onLoad={setLoaded}
        onViewStateChange={setViewport}
        onResize={setViewport}
      >
        {loaded && map.current && typeof children === 'function' && children(map.current)}
      </ReactMapGL>
    </div>
  );
}

MapboxMap.defaultProps = {
  children: null,
  customClass: null,
  bounds: {},
  dragPan: true,
  dragRotate: true,

  onViewportChange: () => {},
  onLoad: () => {}
};

export default MapboxMap;
