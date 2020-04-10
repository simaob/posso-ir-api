import React, { useRef, useCallback } from 'react';
import cx from 'classnames';
import ReactMapGL, { FlyToInterpolator } from 'react-map-gl';
import { easeCubic } from 'd3-ease';
import { useOnLoad } from './use-on-load';
import { useViewport } from './use-viewport';

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
    doubleClickZoom,
    ...mapboxProps
  } = props;
  const transitionInterpolator = useRef(new FlyToInterpolator());
  const mapContainer = useRef(null);
  const map = useRef(null);
  const getMap = useCallback(instance => {
    map.current = instance.getMap();
  }, []);
  const { viewport, setViewport, fitBounds, flying } = useViewport(props, mapContainer.current);
  const [loaded, setLoaded] = useOnLoad(fitBounds);

  return (
    <div ref={mapContainer} className={cx('c-map', { [customClass]: !!customClass })}>
      <ReactMapGL
        ref={getMap}
        // CUSTOM PROPS FROM REACT MAPBOX API
        {...mapboxProps}
        // VIEWPORT
        {...viewport}
        width="100%"
        height="100%"
        // INTERACTIVE
        dragPan={!flying && dragPan}
        dragRotate={!flying && dragRotate}
        scrollZoom={!flying && scrollZoom}
        touchZoom={!flying && touchZoom}
        touchRotate={!flying && touchRotate}
        doubleClickZoom={!flying && doubleClickZoom}
        // DEFAULT FUNC IMPLEMENTATIONS
        onViewportChange={setViewport}
        onResize={setViewport}
        onLoad={setLoaded}
        transitionInterpolator={transitionInterpolator.current}
        transitionEasing={easeCubic}
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
