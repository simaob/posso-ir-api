module ManageStoresHelper
  def latest_status status
    return 'N/A' unless status

    state = I18n.t("views.manage_stores.index.#{status.status.to_i}")

    if status.valid_until > Time.now
      I18n.t('views.manage_stores.index.state_valid_until',
             state: state,
             time: status.valid_until.strftime('%H:%M, %d/%m/%Y'))
    else
      I18n.t('views.manage_stores.index.state_invalid', state: state)
    end
  end
end
