import React, { useRef } from 'react';
import useOnClickOutside from 'use-onclickoutside';
import cx from 'classnames';

function Sidebar(props) {
  const { shop, dispatch, status } = props;
  const ref = useRef(null);
  const close = () => dispatch({ type: 'clickCloseSidebar' });
  useOnClickOutside(ref, close);

  const dispatchAction = e => {
    const { actionType } = e.target.dataset;
    dispatch({ type: actionType });
  };

  return (
    <aside ref={ref} className={cx('c-sidebar', { '-visible': shop })}>
      <div className="sidebar-header">
        <p className="shop-name">{(shop && shop.name) || 'Create new store'}</p>
        {status === 'idle' && (
          <button type="button" className="close-button" aria-label="Close" onClick={close}>
            close
          </button>
        )}
      </div>
      <div className="sidebar-content">
        <form className="sidebar-form">
          {Object.entries(shop || {}).flatMap(([name, value]) => (
            <FormField key={name} name={name} value={value} status={status} id={`shop-${name}`} />
          ))}
        </form>
      </div>
      <div className="sidebar-footer">
        <div className="sidebar-footer-wrapper">
          {['creating', 'deleting', 'editing'].includes(status) && (
            <>
              <button
                type="button"
                className="btn btn-outline-secondary mr-2"
                onClick={dispatchAction}
                data-action-type="clickCancel"
              >
                Cancel
              </button>
              <button
                type="button"
                className="btn btn-outline-success"
                onClick={dispatchAction}
                data-action-type="clickSave"
              >
                Save
              </button>
            </>
          )}
          {status === 'idle' && (
            <button
              type="button"
              className="btn btn-outline-info"
              onClick={dispatchAction}
              data-action-type="clickEdit"
            >
              Edit
            </button>
          )}
        </div>
      </div>
    </aside>
  );
}

function FormField(props) {
  const { id, value, type = 'text', name, status } = props;
  const readOnly = name === 'id' || ['idle', 'deleting'].includes(status);
  return (
    <div className="form-group">
      <label className="sidebar-label" htmlFor={id}>
        {name}
      </label>
      <input
        id={id}
        type={type}
        readOnly={readOnly}
        defaultValue={value}
        className="form-control"
      />
    </div>
  );
}

export default React.memo(Sidebar);
