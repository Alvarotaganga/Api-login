# Usamos el repositorio oficial de gemas de Ruby
source 'https://rubygems.org'

# Versión de Ruby para asegurar la consistencia entre desarrollo y producción
ruby '3.4.2'  # O la versión que estés utilizando

# Framework Sinatra para construir la API
gem 'sinatra', '4.1.1'  # Aseguramos una versión estable

# Controlador para PostgreSQL
gem 'pg', '1.5.9'  # Aseguramos una versión estable para PostgreSQL

# Para manejar y generar respuestas en formato JSON
gem 'json', '2.10.2'

# Puma como servidor web en producción (recomendado)
gem 'puma', '6.6.0'

# Para manejar configuraciones secretas de forma segura (si utilizas archivos .env)
gem 'dotenv', require: 'dotenv/load'

# Dependencias de desarrollo
group :development do
  # Pry para depuración en desarrollo
  gem 'pry', '0.15.2'

  # rack-attack para proteger la aplicación de posibles ataques HTTP
  gem 'rack-attack', '6.7.0'
end

# Dependencias para las pruebas (si usas RSpec)
group :test do
  # RSpec para pruebas unitarias y de integración
  gem 'rspec', '3.13.0'
end

# Si tu aplicación es parte de un sistema de API más complejo, puedes añadir:
# gem 'jsonapi-serializer' # Si usas JSON:API para respuestas más estructuradas

# Agregar aquí más gemas según las necesidades de tu proyecto
