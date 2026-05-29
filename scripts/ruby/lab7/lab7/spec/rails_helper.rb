# spec/rails_helper.rb
# Цей файл генерується командою `rails generate rspec:install`.
# Додати у нього наступні рядки (або замінити весь файл):

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.fixture_paths = ["#{::Rails.root}/spec/fixtures"]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # FactoryBot — скорочення create/build без префіксу FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Devise — хелпери для request specs
  config.include Devise::Test::IntegrationHelpers, type: :request
end
