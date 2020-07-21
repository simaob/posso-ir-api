module Api
  module V1
    class RankingResource < ApplicationResource
      immutable
      caching

      attributes :user, :position, :score, :reports, :places

      def user
        @model.user&.name || 'User' + rand(1..1000).to_s
      end

      def self.records(options = {})
        current_user = options[:context][:current_user]
        user_rank = Ranking.where user_id: current_user.id

        super(options).or(user_rank).joins(:user).limit(100)
      end

      exclude_links :default
    end
  end
end
