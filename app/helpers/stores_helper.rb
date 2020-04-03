module StoresHelper
  def badge_for store
    klass = case store.state
            when 'live'
              'badge-success'
            when 'waiting_approval'
              'badge-info'
            when 'marked_for_deletion'
              'badge-warning'
            end
    content_tag(:span, enum_l(store, :state), class: "badge #{klass}")
  end
end
