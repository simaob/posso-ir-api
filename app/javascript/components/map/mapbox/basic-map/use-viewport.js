import { useReducer, useEffect } from 'react';
import { TRANSITION_EVENTS } from 'react-map-gl';
import WebMercatorViewport from 'viewport-mercator-project';

const initialState = {
  status: 'idle', // 'propsChanged', 'stateChanged', 'flying'
  viewport: {
    zoom: 2,
    lat: 0,
    lng: 0
  }
};

function reducer(state, action) {
  const mergeViewport = v => ({ ...state.viewport, ...v });
  function idle(state, action) {
    switch (action.type) {
      case 'newProps': {
        return {
          ...state,
          status: 'propsChanged',
          viewport: mergeViewport(action.payload)
        };
      }
      case 'newState': {
        return {
          ...state,
          status: 'stateChanged',
          viewport: mergeViewport(action.payload)
        };
      }
      default:
        return state;
    }
  }
  function stateChanged(state, action) {
    switch (action.type) {
      case 'synced': {
        return {
          ...state,
          status: 'idle'
        };
      }
      default:
        return state;
    }
  }

  function propsChanged(state, action) {
    switch (action.type) {
      case 'synced': {
        return {
          ...state,
          status: 'idle'
        };
      }
      default:
        return state;
    }
  }
  function flying(state, action) {
    switch (action.type) {
      case 'startFlight': {
        return {
          ...state,
          viewport: {
            status: 'flying',
            viewport: mergeViewport(action.payload)
          }
        };
      }
      case 'endFlight': {
        return { ...state, status: 'stateChanged' };
      }
      default:
        return state;
    }
  }

  if (state.status === 'idle') {
    return idle(state, action);
  }
  if (state.status === 'propsChanged') {
    return propsChanged(state, action);
  }
  if (state.status === 'stateChanged') {
    return stateChanged(state, action);
  }
  if (state.status === 'flying') {
    return flying(state, action);
  }
}

export function useViewport(props = {}, container) {
  const [state, dispatch] = useReducer(reducer, { ...initialState, viewport: props.viewport });
  const transitionDuration = 2500;

  useEffect(() => {
    dispatch({ type: 'newProps', payload: props.viewport });
  }, [props.viewport]);

  useEffect(() => {
    if (state.status === 'stateChanged') {
      props.onViewportChange(state.viewport);
    }
    if (['stateChanged', 'propsChanged'].includes(state.status)) {
      dispatch({ type: 'synced' });
    }
  }, [state.status, props.onViewportChange]);

  useEffect(() => {
    let timeout;
    if (state.status === 'flying') {
      timeout = setTimeout(() => dispatch({ type: 'endFlight' }), transitionDuration);
    }
    return () => {
      clearTimeout(timeout);
    };
  }, [state.status === 'flying']);

  const fitBounds = () => {
    if (!props.bounds || !props.bounds.bbox) {
      return;
    }
    const fittedViewport = {
      width: container.offsetWidth,
      height: container.offsetHeight,
      ...state.viewport
    };

    const { longitude, latitude, zoom } = new WebMercatorViewport(fittedViewport).fitBounds(
      [
        [props.bounds.bbox[0], props.bounds.bbox[1]],
        [props.bounds.bbox[2], props.bounds.bbox[3]]
      ],
      props.bounds.options
    );

    const newViewport = {
      longitude,
      latitude,
      zoom,
      transitionDuration,
      transitionInterruption: TRANSITION_EVENTS.UPDATE
    };

    dispatch({ type: 'startFlight', payload: newViewport });
  };

  useEffect(() => {
    if (props.bounds && props.bounds.bbox) {
      fitBounds();
    }
  }, [props.bounds]);

  return {
    fitBounds,
    viewport: state.viewport,
    flying: state.status === 'flying',
    setViewport: payload => dispatch({ type: 'newState', payload })
  };
}
