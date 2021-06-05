class IntroController < ApplicationController
  before_action :validate_params
  @@page_size = 30

  def list
    user = User.find(params['user_id'])
    page = (params['page'] || '1').to_i
    sort = params['sort'] == 'asc' ? :ASC : :DESC
    offers = []

    if page == 1
      offers << MatchHelper.instance.get_pefect_and_good_offers(user)
      offers << RemoteHelper.instance.get_offers(user, params)
    end

    records_to_fecth = @@page_size - offers.size
    offers << MatchHelper
              .instance
              .get_other_offers(user, params['department_id'], params['query'],
                                (page - 1) * records_to_fecth, records_to_fecth, sort)

    render json: offers.flatten
  end

  private

  def validate_params
    params.permit(:user_id, :page, :query, :sort, department_id: [])
    raise 'user_id is mandatory' unless params.include?(:user_id)
  rescue StandardError => e
    render json: { error: e }, status: 400
  end
end
