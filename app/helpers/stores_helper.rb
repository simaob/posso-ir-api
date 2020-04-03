module StoresHelper
  def badge_for(store)
    content_tag(:span, enum_l(store, :state), class: "badge #{state_klass(store)}")
  end

  def state_klass(store)
    case store.state
    when 'live'
      'badge-success'
    when 'waiting_approval'
      'badge-info'
    when 'marked_for_deletion'
      'badge-warning'
    end
  end
end
