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
	#  Инициализация базы данных
	init_db
end

#   Все что находится сдесь инициализируется при каждом запуске или сохранении файла
configure do
	#   При инициализации метод должен быть в configure 
	init_db
	#   Создает таблицу
	#   IF NOT EXISTS пишется для того чтобы при инициализации если такая БД уже есть не создавать ее повторно
	@db.execute 'CREATE TABLE if not exists Posts  
	           (
	              id INTEGER PRIMARY KEY AUTOINCREMENT, 
	              created_date DATE, 
	              content TEXT
	            )'

	@db.execute 'CREATE TABLE if not exists Comments  
	           (
	              id INTEGER PRIMARY KEY AUTOINCREMENT, 
	              created_date DATE, 
	              content TEXT,
	              post_id integer
	            )'
end

get '/' do

	#  Выбираем список постов из БД
	@results = @db.execute 'SELECT * FROM Posts order by id desc'

	erb :index
end

get '/new' do
	erb :new
end

post '/new' do

	content = params['content']
	#   Проверка на наличие введенных пользователем данных в окне сообщения
	if content.length <= 0 
		@error = 'Введите сообщение!'
		return erb :new
	end

	@db.execute 'INSERT INTO Posts (content, created_date) VALUES (?, datetime())', [content]


	#  перенаправление на главную страницу
	redirect to '/'

end

#   вывод информации о посте

get '/details/:post_id' do
	#   Получаем переменную из url
	post_id = params[:post_id]
	#   Получаем список постов, при данном запросе у нас выбирается одна строка из БД с id из post_id
	results = @db.execute 'SELECT * FROM Posts where id = ?', [post_id]
	#  Записываем эту строку из БД в переменную
	@row = results[0]

	erb :details

end	

#  обрваботчик POST запроса (принимаем данные от браузера)
post '/details/:post_id' do

	post_id = params[:post_id]

	content = params[:content]

	erb "Вы ввели комментарий #{content} с идентификатором #{post_id}"

end
