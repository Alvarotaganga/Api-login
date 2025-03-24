require './config/environment'
require 'sinatra'
require 'pg'
require 'json'
require 'bcrypt'

# Configuración básica
set :port, ENV['PORT'] || 4567
set :bind, '0.0.0.0'
set :environment, ENV['RACK_ENV'] || :production

# Configuración de CORS
configure do
  enable :cross_origin
  enable :logging
end

before do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = ENV['ALLOWED_ORIGIN'] || '*'
  response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
end

options '*' do
  200
end

# Conexión segura a PostgreSQL con SSL
def db_connection
  @db_connection ||= begin
    uri = URI.parse(ENV['DATABASE_URL'])
    PG.connect(
      host: uri.host,
      port: uri.port,
      dbname: uri.path[1..-1],
      user: uri.user,
      password: uri.password,
      sslmode: 'require',
      connect_timeout: 5
    )
  rescue PG::Error => e
    puts "Error de conexión a DB: #{e.message}"
    raise
  end
end

# Helper para validar emails
def valid_email?(email)
  email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
end

# Endpoints
get '/usuarios' do
  users = db_connection.exec('SELECT id, nombre, email, fecha_registro FROM usuarios')
  users.to_json
end

get '/usuario/:id' do
  id = params[:id].to_i
  result = db_connection.exec_params(
    'SELECT id, nombre, email, fecha_registro FROM usuarios WHERE id = $1', 
    [id]
  )

  if result.ntuples.positive?
    result.first.to_json
  else
    status 404
    { error: 'Usuario no encontrado' }.to_json
  end
end

post '/usuario' do
  data = JSON.parse(request.body.read)
  
  # Validaciones
  required_fields = ['nombre', 'email', 'password']
  missing_fields = required_fields.select { |field| data[field].to_s.empty? }
  
  unless missing_fields.empty?
    status 400
    return { error: "Campos requeridos: #{missing_fields.join(', ')}" }.to_json
  end

  unless valid_email?(data['email'])
    status 400
    return { error: 'Formato de email inválido' }.to_json
  end

  # Hash de contraseña
  hashed_pw = BCrypt::Password.create(data['password'])

  begin
    result = db_connection.exec_params(
      'INSERT INTO usuarios (nombre, email, password) VALUES ($1, $2, $3) RETURNING id, nombre, email',
      [data['nombre'], data['email'], hashed_pw]
    )
    status 201
    result.first.to_json
  rescue PG::UniqueViolation
    status 409
    { error: 'El email ya está registrado' }.to_json
  rescue PG::Error => e
    status 500
    { error: 'Error al crear usuario', details: e.message }.to_json
  end
end

put '/usuario/:id' do
  id = params[:id].to_i
  data = JSON.parse(request.body.read)

  # Validaciones
  if data['email'] && !valid_email?(data['email'])
    status 400
    return { error: 'Formato de email inválido' }.to_json
  end

  updates = []
  params = []
  
  ['nombre', 'email', 'password'].each_with_index do |field, index|
    if data[field]
      updates << "#{field} = $#{index + 1}"
      params << (field == 'password' ? BCrypt::Password.create(data[field]) : data[field])
    end
  end

  if updates.empty?
    status 400
    return { error: 'No hay campos para actualizar' }.to_json
  end

  params << id
  query = "UPDATE usuarios SET #{updates.join(', ')} WHERE id = $#{params.length} RETURNING id, nombre, email"

  begin
    result = db_connection.exec_params(query, params)
    if result.ntuples.positive?
      result.first.to_json
    else
      status 404
      { error: 'Usuario no encontrado' }.to_json
    end
  rescue PG::UniqueViolation
    status 409
    { error: 'El email ya está en uso' }.to_json
  rescue PG::Error => e
    status 500
    { error: 'Error al actualizar usuario', details: e.message }.to_json
  end
end

delete '/usuario/:id' do
  id = params[:id].to_i
  result = db_connection.exec_params(
    'DELETE FROM usuarios WHERE id = $1 RETURNING id',
    [id]
  )

  if result.ntuples.positive?
    { message: 'Usuario eliminado exitosamente' }.to_json
  else
    status 404
    { error: 'Usuario no encontrado' }.to_json
  end
end

# Manejo de errores
error PG::Error do
  status 500
  { error: 'Error de base de datos', details: env['sinatra.error'].message }.to_json
end

not_found do
  { error: 'Ruta no encontrada' }.to_json
end