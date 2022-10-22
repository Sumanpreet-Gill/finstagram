helpers do

  def current_user
      User.find_by(id: session[:user_id])
  end

end

# Controller
# Handles client HTTP requests and sends web server HTTP responses

# ACTIONS / ROUTES

# Handle the GET request for '/' (Display all the Finstagram Posts) - READ
get '/' do
  @finstagram_posts = FinstagramPost.order(created_at: :desc)
  erb(:index)
end

# Handle the GET request for '/signup' (Display a form to signup) - READ
get '/signup' do
  @user = User.new
  erb(:signup)
end

# Handle the POST request for '/signup' (Create a User) - CREATE
post '/signup' do
  email = params[:email]
  avatar_url = params[:avatar_url]
  username = params[:username]
  password = params[:password]

  # instantiate a User object
  @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })

  if @user.save
      redirect to('/login')
  else
      erb(:signup)
  end
end

# Handle the GET request for /login (Display a form to login) - READ
get '/login' do
  erb(:login)
end

# Handle the GET request for /login (Display a form to login) - READ
post '/login' do
  username = params[:username]
  password = params[:password]

  user = User.find_by(username: username)

  if user && user.password == password
      session[:user_id] = user.id
      redirect to('/')
  else
      @error_message = "Login Failed"
      erb(:login)
  end
end

# Handle the GET request for /logout
get '/logout' do
  session[:user_id] = nil
  redirect(to('/'))
end

# Handle the POST request for /finstagram_posts/new
get '/finstagram_posts/new' do
  @finstagram_post = FinstagramPost.new
  erb(:"finstagram_posts/new")
end

# Handle the POST request for /finstagram_posts
post '/finstagram_posts' do
  photo_url = params[:photo_url]

  @finstagram_post = FinstagramPost.new({photo_url: photo_url, user_id: current_user.id})

  if @finstagram_post.save
      redirect(to('/'))
  else
      erb(:"finstagram_posts/new")
  end
end

# Handle the GET request for /finstagram_posts/:id
get '/finstagram_posts/:id' do
  @finstagram_post = FinstagramPost.find_by(id: params[:id])
  erb(:"finstagram_posts/show")
end