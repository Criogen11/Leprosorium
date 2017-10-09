require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

#  Создание подключения к базе
def init_db
	#  Создаем глобальную переменную которая ссылается на базу данных Leprosorium.db
	@db = SQLite3::Database.new 'leprosorium.db'
	# Включаем функцию которая возвращает результат запроса в виде хеша а не в виде массива
	@db.results_as_hash = true
end	

#   Данная фенкция позволяет видеть все что в ней находится при каждом обращении GET или POST
before do

end

get '/' do
	erb 'Can you handle a <a href="/secure/place">secret</a>?'
end

get '/new' do
	erb :new
end

post '/new' do


	content = params['content']

end

