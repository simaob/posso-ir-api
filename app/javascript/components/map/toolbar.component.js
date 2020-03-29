import React from 'react';
import capitalize from 'lodash/capitalize';

function Toolbar(props) {
  const { status, dispatch } = props;
  const dispatchAction = e => {
    const { actionType } = e.target.dataset;
    dispatch({ type: actionType });
  };

  return (
    <div className="c-toolbar">
      <div className="toolbar-wrapper d-flex justify-content-between align-items-center">
        <div>
          {status !== 'idle' && <h3 className="toolbar-title">{capitalize(`${status} store`)}</h3>}
        </div>
        <div>
          {status === 'idle' && (
            <>
              <button
                type="button"
                className="btn btn-outline-primary mr-2"
                onClick={dispatchAction}
                data-action-type="clickAdd"
              >
                Add store
              </button>
              <button
                type="button"
                className="btn btn-outline-danger"
                onClick={dispatchAction}
                data-action-type="clickDelete"
              >
                Delete store
              </button>
            </>
          )}
          {status !== 'idle' && (
            <button
              type="button"
              className="btn btn-outline-secondary mr-2"
              onClick={dispatchAction}
              data-action-type="clickCancel"
            >
              Cancel
            </button>
          )}
        </div>
      </div>
    </div>
  );
}

export default React.memo(Toolbar);
