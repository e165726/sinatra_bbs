require 'sinatra'
require 'sinatra/reloader'
require 'dotenv/load'
require 'pg'

get '/' do
  db = PG::connect(:dbname => 'bbs')
  @sql = db.exec("SELECT * FROM boards")
  erb :index
end

post '/posts' do
  name = params[:name]
  email = params[:email]
  message = params[:message]

	unless name.empty? || email.empty? || message.empty?
		db = PG::connect(:dbname => 'bbs')
		db.exec("insert into boards (name, email, message) values($1, $2, $3)", [name, email, message])
	end
  redirect "/"
end

get '/delete/:id' do
	db = PG::connect(:dbname => 'bbs')
  @item = db.exec("SELECT * FROM boards where $1", params[:id])
	erb :delete
end

post '/delete/:id' do
  if params.has_key?("ok")
  	item = db.exec("SELECT * FROM boards where $1", params[:id])
    item.destroy
  end
  redirect '/'
end
