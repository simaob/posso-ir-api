require 'rails_helper'

describe Api::V1::StatusCrowdsourceUsersController do
  context 'create' do
    let(:store) { create(:store) }
    let(:params) { {data: {type: 'status_crowdsource_users', attributes: {status: 10, 'store-id': store.id}}} }

    it 'does not authorize unauthenticated requests' do
      post api_v1_status_crowdsource_users_path

      assert_response :unauthorized
    end

    it 'allows authenticated requests' do
      sign_in create(:user)

      post(
        api_v1_status_crowdsource_users_path,
        params: params.to_json,
        headers: {'Content-Type': 'application/vnd.api+json'}
      )

      assert_response :created
    end

    it 'throttles too many requests' do
      sign_in create(:user)

      post(
        api_v1_status_crowdsource_users_path,
        params: params.to_json,
        headers: {'Content-Type': 'application/vnd.api+json'}
      )

      assert_response :created

      post(
        api_v1_status_crowdsource_users_path,
        params: params.to_json,
        headers: {'Content-Type': 'application/vnd.api+json'}
      )

      assert_response :too_many_requests
    end
  end
end
