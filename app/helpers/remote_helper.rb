require 'httparty'
require 'singleton'
require_relative '../extensions/array'

class RemoteHelper
  include Singleton

  def get_offers(user, search_params)
    departments = user.departments.map(&:id)
    response = HTTParty.get('https://bravado.co/api/api/opportunity/intros.json?',
                            { query: { page: search_params[:page] || 1 } })
    intros = response.parsed_response['intros']

    perfect = perfect_matches(intros, user.company, departments)
    good = good_matches(intros, user.company, departments)
    best_five_remaining = best_five_remaining(intros - perfect - good, search_params)

    unless search_params['sort'].nil?
      best_five_remaining = best_five_remaining.sort_by_price(search_params['sort'] == 'asc')
    end

    perfect = perfect.to_serialized_offer(%i[perfect_match from_api])
    good = good.to_serialized_offer(%i[good_match from_api])
    best_five_remaining = best_five_remaining.to_serialized_offer(:from_api)

    [perfect, good, best_five_remaining].flatten[0..4]
  end

  private

  def perfect_matches(intros, company, departments)
    intros.select do |intro|
      intro['request_company']['name'] == company && intro['departments'].any? do |dep|
        departments.include?(dep['id'])
      end
    end
  end

  def good_matches(intros, company, departments)
    intros.select do |intro|
      intro['request_company']['name'] == company && intro['departments'].none? do |dep|
        departments.include?(dep['id'])
      end
    end
  end

  def best_five_remaining(intros, params)
    intros.select do |intro|
      (params['query'].nil? || intro['request_company']['name'].downcase.include?(params['query'])) &&
        (params['department_id'].nil? || intro['departments'].any? do |dep|
           params['department_id'].include?(dep['id'])
         end)
    end[0..4]
  end
end
