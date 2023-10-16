Given("I am an authorized technician") do
  @username = ENV["MOCK_USERNAME"]
  @password = ENV["MOCK_PASSWORD"]
end

When("I request a new token") do
  visit("/")
  click_button("Log in")
end

Then("I am directed to an upstream identity provider") do
  expect(page.current_url).to match(/^#{Regexp.escape(ENV["DEX_URL"])}/)
end

Given("I have already requested a new token") do
  visit("/")
  click_button("Log in")
end

When("I prove my identity") do
  expect(page).not_to have_text(/invalid/i)
  find_field(id: "login").set(@username)
  fill_in("Password", with: @password)
  click_button("Login")
end

Then("I receive a token that will work for kubernetes") do
  expect(find("pre").text).to match(/--auth-provider-arg=id-token=[-_0-9A-Za-z]+\.[-_0-9A-Za-z]+\.[-_0-9A-Za-z]+/)
end

Given("I am not an authorized technician") do
  @username = "malefactor@realcanadianpharmacy.ru"
  @password = "admin"
end

Then("I do not receive a token") do
  expect(page.current_url).to match(/^#{Regexp.escape(ENV["DEX_URL"])}/)
  expect(page).to have_text(/invalid/i)
end
