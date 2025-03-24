require './config/environment'

require 'sinatra'
require 'pg'
require 'json'

# Establecer el puerto dinámico según el entorno
set :port, ENV['PORT'] || 4567

db = PG.connect(host: 'localhost', dbname: 'login_usuario', user: 'postgres', password: '1234')

before do
  content_type :json
end

# Mostrar todos los usuarios
get '/usuarios' do
  users = db.exec('SELECT * FROM usuarios')
  users.map do |user|
    {
      id: user['id'],
      nombre: user['nombre'],
      email: user['email'],
      fecha_registro: user['fecha_registro']
    }
  end.to_json
end

# Mostrar un usuario específico por ID
get '/usuario/:id' do
  id = params[:id].to_i
  result = db.exec_params('SELECT * FROM usuarios WHERE id = $1', [id])

  if result.ntuples > 0
    usuario = result.first
    content_type :json
    {
      id: usuario['id'],
      nombre: usuario['nombre'],
      email: usuario['email'],
      fecha_registro: usuario['fecha_registro']
    }.to_json
  else
    status 404
    { error: 'Usuario no encontrado' }.to_json
  end
end

# Crear un usuario
post '/usuario' do
  data = JSON.parse(request.body.read)
  nombre = data['nombre']
  email = data['email']
  password = data['password']

  db.exec_params('INSERT INTO usuarios (nombre, email, password) VALUES ($1, $2, $3)', [nombre, email, password])

  content_type :json
  { message: 'Usuario creado exitosamente' }.to_json
end

# Actualizar un usuario
put '/usuario/:id' do
  data = JSON.parse(request.body.read)
  id = params[:id].to_i
  nombre = data['nombre']
  email = data['email']
  password = data['password']

  result = db.exec_params(
    'UPDATE usuarios SET nombre = $1, email = $2, password = $3 WHERE id = $4 RETURNING id, nombre, email, password',
    [nombre, email, password, id]
  )

  if result.ntuples > 0
    usuario = result.first
    content_type :json
    { message: 'Usuario actualizado exitosamente', usuario: usuario }.to_json
  else
    status 404
    content_type :json
    { error: 'Usuario no encontrado' }.to_json
  end
end

# Eliminar un usuario
delete '/usuario/:id' do
  id = params[:id].to_i
  result = db.exec_params('DELETE FROM usuarios WHERE id = $1 RETURNING id', [id])

  if result.ntuples > 0
    content_type :json
    { message: 'Usuario eliminado exitosamente' }.to_json
  else
    status 404
    content_type :json
    { error: 'Usuario no encontrado' }.to_json
  end
end
