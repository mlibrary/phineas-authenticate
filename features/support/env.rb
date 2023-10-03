require "capybara/cucumber"

# This requires a web driver to be installed, and we went with gecko:
# https://github.com/mozilla/geckodriver/releases
Capybara.default_driver = :selenium_headless
Capybara.app_host = ENV["APP_URL"]
Capybara.enable_aria_label = true
