require 'sinatra'
require 'sinatra/reloader'
require 'dotenv/load'
require 'pg'

# def connection
#   begin
#     return PG::connect(:dbname => 'bbs')
#   rescue PG::Error => e
#     puts e.message
#   ensure
#     PG::connect(:dbname => 'bbs').close
#   end
# end

get '/' do
  connection = PG::connect(:dbname => 'bbs')
  @sql = connection.exec("SELECT * FROM boards")
  erb :index
end

post '/posts' do
  name = params[:name]
  email = params[:email]
  message = params[:message]
  
  connection = PG::connect(:dbname => 'bbs')
  connection.exec("insert into boards (name, email, message) values($1, $2, $3)",[name, email, message])
  redirect "/"
end

