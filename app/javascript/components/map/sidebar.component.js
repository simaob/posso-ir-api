import React, { useRef } from 'react';
import useOnClickOutside from 'use-onclickoutside';

function Sidebar(props) {
  const { shop, dispatch } = props;
  const ref = useRef(null);
  const close = () => dispatch({ type: 'clickCloseSidebar' });
  useOnClickOutside(ref, close);
  return (
    <aside ref={ref} className={`c-sidebar ${shop ? '-visible' : ''}`}>
      {shop && (
        <div className="header">
          <p>{shop.name || `${shop.latitude.toFixed(3)}, ${shop.longitude.toFixed(3)}`}</p>
          <button type="button" className="close-button" aria-label="Close" onClick={close}>
            close
          </button>
        </div>
      )}
    </aside>
  );
}

export default React.memo(Sidebar);
