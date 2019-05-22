require 'sinatra'
require 'sinatra/reloader'
require 'dotenv/load'
require 'pg'
require 'pry'

use Rack::MethodOverride
enable :sessions

# dbのポートにアクセスできたらtrueを返す
def connecting_db
  begin
  TCPSocket.open('db', 5432)
  rescue
    false
  else
    true
  end
end

# dbに繋げられる状態まで1秒ずつ待つ
while !connecting_db
  sleep 1
end

$db = PG::connect(
  :host => "db",
  :user => 'sinatra', :password => 'sinatra',
  :dbname => "bbs"
  )

helpers do
  def current_user
    return unless session[:email]
    $db.exec_params('select * from users where email = $1', [session[:email]]).first
  end
end

get '/' do
  hoge = ""
  $db.exec_params('SELECT * FROM users;').each do |data|
    hoge += "<p>"+data["name"]+"</p>"
  end
  hoge
  # @sql = $db.exec_params("SELECT * FROM board")
  # @images = Dir.glob("./public/image/*").map{|path| path.split('/').last }
  # erb :index
end

get '/login' do
  # session[:name] = nil
  session[:email] = nil
  erb :login
end

post '/login' do
  email = params[:email]
  password = params[:password]

  users = $db.exec_params('select * from users where email = $1 and password = $2', [email, password]).first
  session[:email] = email unless users.nil?

  redirect to ('/login') if session[:email].nil?
  redirect to ('/')
end

get '/signup' do
  erb :signup
end

post '/signup' do
  name = params[:name]
  email = params[:email]
  password = params[:password]

  $db.exec_params('INSERT INTO users (name, email, password) VALUES ($1,$2,$3)', [name, email, password])
  session[:mail] = mail

  redirect to('/')
end

post '/posts' do
  name = params[:name]
  email = params[:email]
  message = params[:message]

  unless name.empty? || email.empty? || message.empty?
    $db.exec_params('INSERT INTO board (name, email, message) VALUES ($1,$2,$3)', [name, email, message])
  end

  redirect to('/')
end

# get '/delete/:id' do
#   @item = db.exec("SELECT * FROM boards where $1", params[:id])
# 	erb :delete
# end

delete '/delete/:id' do
    $db.exec_params('DELETE FROM board where id = $1', [params[:id]])
  redirect '/'
end

post '/upload' do
  @filename = params[:file][:filename]
  tmp = params[:file][:tempfile]

  FileUtils.mv(tmp, "./public/image/#{@filename}")

  redirect to ('/')
end

