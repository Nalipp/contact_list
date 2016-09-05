require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

configure do
  enable :sessions
  set :port, 9494
  set :session_secret, 'secret'
  set :erb, :escape_html => true
end

before do
  session[:contacts] ||= []
  session[:errors] ||= []
end

get '/' do
  redirect '/contacts'
end

get '/contacts' do
  @contacts = session[:contacts]
  erb :contacts
end

get '/new_contact' do
  erb :new_contact
end

def length_too_long_validation?
  return true if params[:name].length > 100
  return true if params[:phone].length > 100
  return true if params[:email].length > 100
  false
end

def value_missing_validation?
  errors = []
  errors << "Name value is missing" if params[:name].empty?
  errors << "Phone value is missing" if params[:phone].empty?
  errors << "Email value is missing" if params[:email].empty?
  errors.empty? ? false : errors
end

post '/new_contact' do
 @name = params[:name]
 @phone = params[:phone]
 @email = params[:email]
 @friend = params[:friend]
 @family = params[:family]
 @work = params[:work]

 if length_too_long_validation?
   session[:errors] << "Input values must be less than 100 characters"
   erb :new_contact
 elsif error = value_missing_validation?
    session[:errors] << error
    erb :new_contact
 else
   session[:contacts] << { name: @name, phone: @phone, email: @email, friend: @friend, family: @family, work: @work }
   redirect '/contacts'
 end
end
