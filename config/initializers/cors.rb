Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:5173' # le port de ton frontend
  
      resource '*',
        headers: :any,
        methods: [:get, :post, :patch, :put, :delete, :options, :head],
        expose: ['Authorization']
    end
  end
  