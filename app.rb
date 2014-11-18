require 'bundler'
Bundler.require

#development or production
set :environment, :development
#set :environment, :production

CKEY = '1uAH8P1AbyBg1wdKQ3BVDXdKe'
CSEC = 'q9YpP6yt7vIMEhed0NFnk63ZwtJPTwoysrItyNZUtFr7HQN7ov'

configure :development do
	set :server, 'webrick'
	require 'sinatra/reloader'
	Slim::Engine.set_default_options :pretty => true
end

configure do
	register Sinatra::AssetPack
	assets do
		serve '/js', from: 'assets/js'
		serve '/css', from: 'assets/css'

		js :application, [
			'/js/*.js'
		]

		css :application, [
			'/css/*.css'
		]

		js_compression :closure, :level => "SIMPLE_OPTIMIZATIONS"
		css_compression :sass
	end

	enable :sessions
	use OmniAuth::Builder do
		CONSUMER_KEY = CKEY
		CONSUMER_SECRET = CSEC
		provider :twitter, CONSUMER_KEY, CONSUMER_SECRET
	end
end

helpers do
	def current_user
		session[:userid].nil?
	end
end

get '/auth/twitter/callback' do
	session[:userid] = env['omniauth.auth']['uid']
	session[:username] = env['omniauth.auth']['info']['nickname']
	session[:token] = env['omniauth.auth'][:credentials][:token]
	session[:secret] = env['omniauth.auth'][:credentials][:secret]
	redirect to('/')
end

get '/logout' do
	session.clear
	redirect to('/')
end

# get '/auth/failure' do
# 	# omniauth redirects to /auth/failure when it encounters a problem
# 	# so you can implement this as you please
# end

get '/' do
	if current_user
		slim :prelogin
	else
		@userid = session[:userid]
		@username = session[:username]
		slim :logined
	end
end

post '/tweet' do
	if current_user
		slim :prelogin
	else
		client = Twitter::REST::Client.new do |config|
			config.consumer_key = CKEY
			config.consumer_secret = CSEC
			config.access_token = session[:token]
			config.access_token_secret = session[:secret]
		end
		client.update "Hello! " + Time.now.strftime("%m-%d %H:%M:%S")
		redirect to('/')
	end
end
