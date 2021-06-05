require 'singleton'

class MatchHelper
  include Singleton

  def get_pefect_and_good_offers(user)
    departments = user.departments.map(&:id)
    matches = Offer.matches(user.company)
    perfect_matches = matches.select { |item| item.departments.any? { |dep| departments.include?(dep.id) } }
    good_matches = matches - perfect_matches

    [
      perfect_matches.map { |offer| offer.serialize(:perfect_match) },
      good_matches.map { |offer| offer.serialize(:good_match) }
    ]
  end

  def get_other_offers(user, department_ids, query, skip, take, sort)
    condition = ''
    parameters = {}

    unless department_ids.nil?
      condition += 'departments.id IN (:ids)'
      parameters[:ids] = department_ids
    end

    unless query.nil?
      condition += ' AND ' unless condition.empty?
      condition += 'company ILIKE :query'
      parameters[:query] = "%#{query}%"
    end

    offers = Offer.not_matched(user.company)
                  .joins(:departments)
                  .where(condition, parameters)
                  .order(price: sort)
                  .offset(skip)
                  .limit(take)
    offers.map(&:serialize)
  end
end
