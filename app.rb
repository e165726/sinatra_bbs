require 'sinatra'
require 'sinatra/reloader'
require 'dotenv/load'
require 'pg'

use Rack::MethodOverride

db = PG::connect(
  :host => "localhost",
  :user => 'e165726', :password => '',
	:dbname => "bbs")

get '/' do
  @sql = db.exec_params("SELECT * FROM board")
  @images = Dir.glob("./public/image/*").map{|path| path.split('/').last }
  erb :index
end

get '/login' do
  session[:name] = nil
  erb :login
end

post '/login' do
  name = params[:name]
  password = params[:password]

  users = db.exec_params('select * from users')

  users.each do |user|
    if user['name'] == name && user['password'] == password
      session[:name] = name
      @current_user = session[:name]
    end
  end

  redirect to ('/login') if session[:name].nil?
  redirect to ('/')
end

post '/signup' do
  name = params[:name]
  email = params[:email]
  password = params[:password]

  db.exec_params('INSERT INTO users (name, email, password) VALUES ($1,$2,$3)', [name, email, password])
  session[:name] = name

  redirect to('/')
end

get '/signup' do
  erb :signup
end

post '/posts' do
  name = params[:name]
  email = params[:email]
  message = params[:message]

  unless name.empty? || email.empty? || message.empty?
    db.exec_params('INSERT INTO board (name, email, message) VALUES ($1,$2,$3)', [name, email, message])
  session[:name] = name
  end
  redirect to ('/')
end

# get '/delete/:id' do
#   @item = db.exec("SELECT * FROM boards where $1", params[:id])
# 	erb :delete
# end

delete '/delete/:id' do
    db.exec_params('DELETE FROM board where id = $1', [params[:id]])
  redirect '/'
end

post '/upload' do
  @filename = params[:file][:filename]
  tmp = params[:file][:tempfile]

  FileUtils.mv(tmp, "./public/image/#{@filename}")

  erb :index
end

