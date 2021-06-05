# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

ActiveRecord::Base.transaction do
  csv_text = File.read(Rails.root.join('lib', 'seeds', 'departments.csv'))
  csv = CSV.parse(csv_text)
  csv.each do |row|
    dep = Department.new
    dep.id = row[0]
    dep.name = row[1]
    dep.save
  end

  csv_text = File.read(Rails.root.join('lib', 'seeds', 'offers.csv'))
  csv = CSV.parse(csv_text)
  csv.each do |row|
    off = Offer.new
    off.id = row[0]
    off.price = row[1]
    off.company = row[2]
    off.save
  end

  csv_text = File.read(Rails.root.join('lib', 'seeds', 'users.csv'))
  csv = CSV.parse(csv_text)
  csv.each do |row|
    usr = User.new
    usr.id = row[0]
    usr.name = row[1]
    usr.company = row[2]
    usr.save
  end

  csv_text = File.read(Rails.root.join('lib', 'seeds', 'offer_departments.csv'))
  csv = CSV.parse(csv_text)
  csv.each do |row|
    off = Offer.find(row[1])
    dep = Department.find(row[2])
    off.departments = [dep]
    off.save
  end

  csv_text = File.read(Rails.root.join('lib', 'seeds', 'user_departments.csv'))
  csv = CSV.parse(csv_text)
  csv.each do |row|
    usr = User.find(row[1])
    dep = Department.find(row[2])
    usr.departments = [dep]
    usr.save
  end
end
