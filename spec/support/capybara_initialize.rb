require 'capybara/rails'
require 'capybara/rspec'

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.configure do |c|
  c.javascript_driver = :selenium_chrome
  c.default_driver = :selenium_chrome
end


