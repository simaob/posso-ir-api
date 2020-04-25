module Support
  module Session
    [:get, :post, :put, :patch, :delete].each do |method|
      define_method method do |path, **args|
        if @auth
          args = args.merge(
            headers: (
              args[:headers] || {}
            ).merge('Authorization' => @auth)
          )
        end

        super(path, **args)
      end
    end

    def sign_in(user)
      if user.is_a? String
        @auth = "Bearer #{user}"
      elsif user.is_a? User
        @auth = "Bearer #{user.api_key.access_token}"
      end
    end

    def clear_session
      @auth = nil
    end
  end
end
