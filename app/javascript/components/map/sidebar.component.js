import React, { useState, useRef } from 'react';
import useOnClickOutside from 'use-onclickoutside';
import cx from 'classnames';

function Sidebar(props) {
  const { shop, dispatch, status } = props;
  const sidebarRef = useRef(null);
  const formRef = useRef(null);
  const [formState, setFormState] = useState({});

  const close = () => dispatch({ type: 'clickCloseSidebar' });
  useOnClickOutside(sidebarRef, close);

  const onSave = () => {
    dispatch({ type: 'clickSave', payload: formState });
  };

  return (
    <aside ref={sidebarRef} className={cx('c-sidebar', { '-visible': shop })}>
      <div className="sidebar-header">
        <p className="shop-name">{(shop && shop.name) || 'Create new store'}</p>
        {status === 'idle' && (
          <button type="button" className="close-button" aria-label="Close" onClick={close}>
            close
          </button>
        )}
      </div>
      <div className="sidebar-content">
        <form className="sidebar-form" ref={formRef}>
          {Object.entries(shop || {}).flatMap(([name, value]) => (
            <FormField
              key={name}
              name={name}
              value={value}
              status={status}
              id={`shop-${name}`}
              onChange={e => {
                e.persist();
                setFormState(formState => ({ ...formState, [name]: e.target.value }));
              }}
            />
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
                onClick={() => dispatch({ type: 'clickCancel' })}
              >
                Cancel
              </button>
              <button type="button" onClick={onSave} className="btn btn-outline-success">
                Save
              </button>
            </>
          )}
          {status === 'idle' && shop && (
            <button
              type="button"
              className="btn btn-outline-info"
              onClick={() => dispatch({ type: 'clickEdit' })}
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
  const { id, value, type = 'text', name, status, onChange } = props;
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
        onChange={onChange}
      />
    </div>
  );
}

export default React.memo(Sidebar);
