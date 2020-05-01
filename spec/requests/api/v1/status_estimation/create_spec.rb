require 'rails_helper'

describe Api::V1::StatusEstimationsController do
  context 'create' do
    let(:store) { create(:store) }
    let(:params) { {status: 10, 'store-id': store.id} }
    let(:params_404) { {status: 10, 'store-id': 1000} }
    let(:params_no_status) { {'store-id': store.id} }
    let(:params_wrong) { {status: -10, 'store-id': store.id} }

    it 'does not authorize unauthenticated requests' do
      post api_v1_status_estimations_path

      assert_response :unauthorized
    end

    it 'does not allow non admins' do
      sign_in create(:user)

      post(
          api_v1_status_estimations_path,
          params: params.to_json,
          headers: {'Content-Type': 'application/vnd.api+json'}
      )

      assert_response :forbidden
    end

    it 'returns 404 if store does not exit' do
      sign_in create(:admin_user, role: 'admin', email: "#{rand(50)}@test.com", password: 'testpass')

      post(
          api_v1_status_estimations_path,
          params: params_404.to_json,
          headers: {'Content-Type': 'application/vnd.api+json'}
      )

      assert_response :not_found
    end

    it 'invalid data for missing store' do
      sign_in create(:admin_user, role: 'admin', email: "#{rand(50)}@test.com", password: 'testpass')

      post(
          api_v1_status_estimations_path,
          params: params_no_status.to_json,
          headers: {'Content-Type': 'application/vnd.api+json'}
      )

      assert_response :bad_request
    end

    it 'Unprocessable entity for wrong status' do
      sign_in create(:admin_user)

      post(
          api_v1_status_estimations_path,
          params: params_wrong.to_json,
          headers: {'Content-Type': 'application/vnd.api+json'}
      )

      assert_response :unprocessable_entity
    end

    it 'allows authenticated requests' do
      sign_in create(:admin_user, role: 'admin', email: "#{rand(50)}@test.com")

      post(
        api_v1_status_estimations_path,
        params: params.to_json,
        headers: {'Content-Type': 'application/vnd.api+json'}
      )

      assert_response :created
    end
  end
end
