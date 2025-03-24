source 'https://rubygems.org'
ruby '3.4.2'

# Gemas esenciales para producción
gem 'sinatra', '~> 4.1.1'
gem 'pg', '~> 1.5.9', '>= 1.5.3'  # PostgreSQL (con versión mínima segura)
gem 'puma', '~> 6.6.0'            # Servidor web de producción
gem 'bcrypt', '~> 3.1.7'          # Hashing de contraseñas (¡CRÍTICO!)
gem 'rack', '~> 3.0'              # Middleware esencial
gem 'rack-protection', '~> 4.1.0' # Seguridad contra ataques web
gem 'json', '~> 2.6'              # Manejo de JSON

# Desarrollo
group :development do
  gem 'dotenv', '~> 3.1', require: 'dotenv/load'  # Variables de entorno
  gem 'pry', '~> 0.15.2'         # Consola interactiva
  gem 'rerun', '~> 0.14.0'       # Recarga automática
  gem 'rack-attack', '~> 6.7.0'  # Protección contra abuso
  gem 'sinatra-contrib', '~> 4.1' # Extensiones útiles para desarrollo
end

# Pruebas
group :test do
  gem 'rspec', '~> 3.13.0'
  gem 'rack-test', '~> 2.1.0'    # Testing de endpoints
  gem 'factory_bot', '~> 6.4'    # Creación de datos de prueba
  gem 'faker', '~> 3.2'          # Datos falsos para pruebas
end

# Herramientas de calidad de código (opcional pero recomendado)
group :development, :test do
  gem 'rubocop', '~> 1.56', require: false
  gem 'rubocop-rspec', '~> 2.23', require: false
  gem 'reek', '~> 6.1', require: false
end