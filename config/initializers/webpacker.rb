Webpacker::Compiler.env["BASE_URL"] = Rails.env.development? || Rails.env.test? ? 'http://localhost:3000' : ''