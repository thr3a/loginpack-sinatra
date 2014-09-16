require 'bundler'
Bundler.require
require "sinatra/reloader" if development?

configure do
	enable :sessions

	use OmniAuth::Builder do
		CONSUMER_KEY = ''
		CONSUMER_SECRET = ''
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