class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_current_user
  before_action :set_locale
  before_action :make_action_mailer_use_request_host_and_protocol

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def set_current_user
    ::Current.user = current_user
  end

  def set_locale
    I18n.locale = params_locale || domain_locale || I18n.default_locale

    response.headers['Content-Language'] = I18n.locale.to_s
  end

  def params_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  DOMAIN_LOCALES = {
    'api.posso-ir.com' => 'pt',
    'api.puedo-ir.es' => 'es',
    'api.puedo-ir.com' => 'es',
    'api.can-i-go.co.uk' => 'en',
    'api.necakajvrade.com' => 'sk'
  }.freeze

  def domain_locale
    DOMAIN_LOCALES[request.host]
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
end
