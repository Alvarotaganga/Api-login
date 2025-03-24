ENV['BUNDLE_PATH'] = '/opt/render/project/.gems'

require './config/environment'

require 'sinatra'
require 'pg'
require 'json'


db = PG.connect(host: 'localhost', dbname: 'login_usuario', user: 'postgres', password: '1234')


before do
  content_type :json
end




#Show all users
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



#Create a user
post '/usuario' do
  # Parsear el cuerpo de la solicitud JSON
  data = JSON.parse(request.body.read)

  # Asignar los valores del JSON a variables locales
  nombre = data['nombre']
  email = data['email']
  password = data['password']

  # Insertar el nuevo usuario en la base de datos
  db.exec_params('INSERT INTO usuarios (nombre, email, password) VALUES ($1, $2, $3)', [nombre, email, password])

  # Consultar el último usuario insertado (opcional)
  @usuarios = db.query("SELECT * FROM usuarios ORDER BY id DESC LIMIT 1")
  
  content_type :json
  # Devuelvo el mensaje de éxito
  { message: 'Usuario creado exitosamente' }.to_json
end


#Delate a user
put '/usuario/:id' do
  # Parsear los datos de la solicitud (en formato JSON)
  data = JSON.parse(request.body.read)

  # Obtener el id del parámetro de la URL
  id = params[:id].to_i

  # Asignar los valores del JSON a variables locales
  nombre = data['nombre']
  email = data['email']
  password = data['password']

  # Realizar la actualización en la base de datos
  result = db.exec_params(
    'UPDATE usuarios SET nombre = $1, email = $2, password = $3 WHERE id = $4 RETURNING id, nombre, email, password',
    [nombre, email, password, id]
  )

  # Verificar si se actualizó algún registro
  if result.ntuples > 0
    # Si se actualizó, devolver el usuario actualizado
    usuario = result.first
    content_type :json
    { 
      message: 'Usuario actualizado exitosamente',
      usuario: usuario
    }.to_json
  else
    # Si no se encontró el usuario, devolver un error
    status 404
    content_type :json
    { 
      error: 'Usuario no encontrado'
    }.to_json
  end
end

#Delete a user
  delete '/usuario/:id' do
    # Obtener el id del parámetro de la URL
    id = params[:id].to_i
  
    # Realizar la eliminación del usuario en la base de datos
    result = db.exec_params('DELETE FROM usuarios WHERE id = $1 RETURNING id', [id])
  
    # Verificar si se eliminó algún registro
    if result.ntuples > 0
      # Si se eliminó, devolver mensaje de éxito
      content_type :json
      { message: 'Usuario eliminado exitosamente' }.to_json
    else
      # Si no se encontró el usuario, devolver un error
      status 404
      content_type :json
      { error: 'Usuario no encontrado' }.to_json
    end
  end
