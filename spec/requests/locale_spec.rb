require 'rails_helper'

describe 'locale' do
  it 'is es when accessing api.puedo-ir.es' do
    get api_v1_stores_url(host: 'api.puedo-ir.es')

    assert_equal 'es', response['Content-Language']
  end

  it 'is es when accessing api.puedo-ir.com' do
    get api_v1_stores_url(host: 'api.puedo-ir.com')

    assert_equal 'es', response['Content-Language']
  end

  it 'is pt when accessing api.posso-ir.com' do
    get api_v1_stores_url(host: 'api.posso-ir.com')

    assert_equal 'pt', response['Content-Language']
  end

  it 'is sk when accessing api.necakajvrade.com' do
    get api_v1_stores_url(host: 'api.necakajvrade.com')

    assert_equal 'sk', response['Content-Language']
  end

  it 'defaults to pt when accessing an unknown domain and there is no user defined locale' do
    get api_v1_stores_url(host: 'example.com')

    assert_equal 'pt', response['Content-Language']
  end

  it 'prioritizes to user defined locale over domain' do
    get api_v1_stores_url(host: 'api.necakajvrade.com', locale: 'es')

    assert_equal 'es', response['Content-Language']
  end

  it 'ignores unknown user defined locales' do
    get api_v1_stores_url(host: 'api.example.com', locale: 'dk')

    assert_equal 'pt', response['Content-Language']
  end
end
