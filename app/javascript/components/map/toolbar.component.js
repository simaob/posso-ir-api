import React from 'react';

function Toolbar(props) {
  const { status, dispatch } = props;
  const dispatchAction = e => {
    const { actionType } = e.target.dataset;
    dispatch({ type: actionType });
  };
  return (
    <div className="c-toolbar">
      <div className="d-flex justify-content-end">
        {status === 'idle' && (
          <>
            <button
              type="button"
              className="btn btn-outline-primary mr-2"
              onClick={dispatchAction}
              data-action-type="clickAdd"
            >
              Add stores
            </button>
            <button
              type="button"
              className="btn btn-outline-danger"
              onClick={dispatchAction}
              data-action-type="clickDelete"
            >
              Delete stores
            </button>
          </>
        )}
        {status !== 'idle' && (
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
      </div>
    </div>
  );
}

export default React.memo(Toolbar);
