module BrowserDriver
  def open_login_app
    visit("/")
  end

  def request_a_new_token
    click_button("Log in")
  end

  def enter_username(username)
    find_field(id: "login").set(username)
  end

  def enter_password(password)
    fill_in("Password", with: password)
  end

  def submit_login_form
    click_button("Login")
  end

  def expect_url_is_upstream_idp
    expect(page.current_url).to match(/^#{Regexp.escape(ENV["DEX_URL"])}/)
  end

  def expect_no_error_messages
    expect(page).not_to have_text(/invalid/i)
  end

  def expect_an_error_message
    expect(page).to have_text(/invalid/i)
  end

  def expect_valid_jwt
    expect(find("pre").text).to match(/--auth-provider-arg=id-token=[-_0-9A-Za-z]+\.[-_0-9A-Za-z]+\.[-_0-9A-Za-z]+/)
  end
end

World(BrowserDriver)
