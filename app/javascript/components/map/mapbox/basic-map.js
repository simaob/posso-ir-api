import React, { useRef, useCallback, useState, useEffect } from 'react';
import cx from 'classnames';
import ReactMapGL, { FlyToInterpolator, TRANSITION_EVENTS } from 'react-map-gl';
import { useOnLoad } from './use-on-load';
import WebMercatorViewport from 'viewport-mercator-project';
import { easeCubic } from 'd3-ease';

function MapboxMap(props) {
  const {
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
    onBoundsChange,
    ...mapboxProps
  } = props;
  const [viewport, setViewport] = useState(null);
  const [flying, setFlying] = useState(false);
  const mapContainer = useRef(null);
  const map = useRef(null);
  const getMap = useCallback(instance => {
    map.current = instance && instance.getMap();
  }, []);

  const onLoad = () => {
    if (!bounds) {
      return;
    }

    const { bbox } = bounds;

    const v = {
      width: mapContainer.current.offsetWidth,
      height: mapContainer.current.offsetHeight,
      ...viewport
    };

    const { longitude, latitude, zoom } = new WebMercatorViewport(v).fitBounds([
      [bbox[0], bbox[1]],
      [bbox[2], bbox[3]]
    ]);

    const newViewport = {
      ...viewport,
      longitude,
      latitude,
      zoom,
      transitionDuration: 2500,
      transitionInterruption: TRANSITION_EVENTS.UPDATE
    };

    setFlying(true);
    setViewport(newViewport);

    const timeout = setTimeout(() => {
      setFlying(false);
    }, 2500);

    return () => {
      clearTimeout(timeout);
    };
  };
  const [loaded, setLoaded] = useOnLoad(onLoad);

  useEffect(() => {
    if (map.current && loaded && !flying) {
      const bounds = map.current.getBounds().toArray();
      onBoundsChange(bounds, viewport);
    }
  }, [viewport, onBoundsChange]);

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
        dragPan={!flying && dragPan}
        dragRotate={!flying && dragRotate}
        scrollZoom={!flying && scrollZoom}
        touchZoom={!flying && touchZoom}
        touchRotate={!flying && touchRotate}
        doubleClickZoom={!flying && doubleClickZoom}
        // DEFAULT FUNC IMPLEMENTATIONS
        onLoad={setLoaded}
        onViewStateChange={loaded ? e => setViewport(e.viewState) : undefined}
        onViewportChange={loaded ? setViewport : undefined}
        onResize={loaded ? setViewport : undefined}
        transitionInterpolator={new FlyToInterpolator()}
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

  onViewportChange: () => {}
};

export default MapboxMap;
