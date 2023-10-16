require "capybara/cucumber"
require "selenium-webdriver"

Capybara.default_driver = :selenium_headless
Capybara.app_host = ENV["APP_URL"]
Capybara.enable_aria_label = true

Selenium::WebDriver.logger.level = :error
