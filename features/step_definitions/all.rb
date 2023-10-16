Given("I am an authorized technician") do
  @username = ENV["MOCK_USERNAME"]
  @password = ENV["MOCK_PASSWORD"]
end

Given("I am not an authorized technician") do
  @username = "malefactor@realcanadianpharmacy.ru"
  @password = "admin"
end

Given("I have already requested a new token") do
  open_login_app
  request_a_new_token
end

When("I request a new token") do
  open_login_app
  request_a_new_token
end

When("I prove my identity") do
  expect_no_error_messages
  enter_username(@username)
  enter_password(@password)
  submit_login_form
end

Then("I am directed to an upstream identity provider") do
  expect_url_is_upstream_idp
end

Then("I receive a token that will work for kubernetes") do
  expect_valid_jwt
end

Then("I do not receive a token") do
  expect_url_is_upstream_idp
  expect_an_error_message
end
