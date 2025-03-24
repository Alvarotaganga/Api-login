# Usamos el repositorio oficial de gemas de Ruby
source 'https://rubygems.org'

# Versión de Ruby para asegurar la consistencia entre desarrollo y producción
ruby '3.4.2'  # O la versión que estés utilizando

# Framework Sinatra para construir la API
gem 'sinatra'

# Controlador para PostgreSQL
gem 'pg'

# Para manejar y generar respuestas en formato JSON
gem 'json'

# Puma como servidor web en producción (recomendado)
gem 'puma'

gem 'rackup'

# Para manejar configuraciones secretas de forma segura (si utilizas archivos .env)
gem 'dotenv', require: 'dotenv/load'

# Dependencias de desarrollo
group :development do
  # Pry para depuración en desarrollo
  gem 'pry'

  # rack-attack para proteger la aplicación de posibles ataques HTTP
  gem 'rack-attack'
end

# Dependencias para las pruebas (si usas RSpec)
group :test do
  # RSpec para pruebas unitarias y de integración
  gem 'rspec'
end

# Si necesitas soporte para tests con bases de datos, por ejemplo, puedes agregar:
# gem 'factory_bot_rails', '~> 6.0'
# gem 'database_cleaner-active_record', '~> 2.0'

# Si tu aplicación es parte de un sistema de API más complejo, puedes añadir:
# gem 'jsonapi-serializer' # Si usas JSON:API para respuestas más estructuradas
