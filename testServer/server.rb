require "sinatra"
require "JSON"

post '/session' do
  data = JSON.parse request.body.read
  username = data["username"]
  password = data["password"] # not used in this example...

  case username
  when "user_with_robots"
    status 201
    JSON.generate( :access_token => "1234" )
  when "user_without_robots"
    status 201
    JSON.generate( :access_token => "5678" )
  else
    status 403
    JSON.generate( :error => "invalid_credentials" )
  end

end

delete '/session' do
  status 200
  "{}"
end

get '/robots' do
  auth_token = read_authorization_token

  case auth_token
  when "1234"
    status 200
    JSON.generate( :robots => [ { :id => "r1", :name => "Eve", :charge => 10 },
                                { :id => "r2", :name => "Jarvis", :charge => 95 },
                              ])
  when "5678"
    status 200
    JSON.generate( :robots => [] )
  else
    status 403
    JSON.generate( :error => "invalid_token" )
  end

end


def read_authorization_token
  token_header_string = request.env["HTTP_AUTHORIZATION"]
  token = token_header_string.gsub("Token token=","")
end
