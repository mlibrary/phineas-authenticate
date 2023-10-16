require "securerandom"
require "json"
require "base64"
require "sinatra"
require "uri"

get "/" do
  <<~WEBPAGE
    <html>
      <body>
        <form action="#{ENV["DEX_URL"]}/auth">
          <input type="hidden" name="client_id" value="app"/>
          <input type="hidden" name="redirect_uri" value="#{ENV["APP_URL"]}/oidc/logged-in"/>
          <input type="hidden" name="response_type" value="code"/>
          <input type="hidden" name="scope" value="openid profile email"/>
          <input type="hidden" name="state" value="#{SecureRandom.base64(50)}"/>
          <input type="submit" value="Log in to Kubernetes"/>
        </form>
      </body>
    </html>
  WEBPAGE
end

get "/oidc/logged-in" do
  post = URI.encode_www_form(
    grant_type: "authorization_code",
    code: params["code"],
    redirect_uri: "#{ENV["APP_URL"]}/oidc/logged-in"
  )

  response = JSON.parse(`curl -vsSX POST -d "#{post}" -H "Authorization: Basic #{Base64.strict_encode64("app:VerySecret")}" #{ENV["DEX_URL"]}/token`)

  <<~WEBPAGE
    <html>
      <body>
        <section aria-labelledby="kubehead">
          <h2 id="kubehead">Type this in with kubectl</h2>
          <pre>kubectl config set-credentials mlibrary|hathitrust --auth-provider=oidc --auth-provider-arg=idp-issuer-url=#{ENV["DEX_URL"]} --auth-provider-arg=client-id=app --auth-provider-arg=client-secret=??? --auth-provider-arg=refresh-token=??? --auth-provider-arg=id-token=#{response["id_token"]}</pre>
        </section>
        <a href="/">Log out</a>
      </body>
    </html>
  WEBPAGE
end
