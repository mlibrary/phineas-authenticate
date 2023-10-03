require "sinatra"

get "/" do
  <<~WEBPAGE
    <html>
      <body>
        <p>Hello!</p>
      </body>
    </html>
  WEBPAGE
end
