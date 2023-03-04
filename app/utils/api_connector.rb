module Utils
  class ApiConnector
    attr_reader :request_domain, :default_headers, :default_params, :ssl_verification, :debug_mode

    def initialize(args)
      raise ArgumentError.new(
        "No se puede inicializar ApiConnector sin el argumento 'request_domain'."
      ) if args[:request_domain].blank?

      @request_domain = args[:request_domain]
      @default_headers = args[:default_headers].present? ? args[:default_headers] : {}
      @default_params = args[:default_params].present? ? args[:default_params] : {}
      @ssl_verification = args[:ssl_verification].present? ? args[:ssl_verification] : true
      @debug_mode = args[:debug_mode].present? ? args[:debug_mode] : false
    end

    def get(resource, params = {}, headers = {})
      self.execute("#{@request_domain}#{resource}", "GET", params, headers)
    end

    def post(resource, body, params = {}, headers = {})
      self.execute("#{@request_domain}#{resource}", "POST", params, body, headers)
    end

    def put(resource, body, params = {}, headers = {})
      self.execute("#{@request_domain}#{resource}", "PUT", params, body, headers)
    end

    def delete resource, params = {}, headers = {}
      self.execute("#{@request_domain}#{resource}", "DELETE", params, headers)
    end

    def patch(resource, body, params = {}, headers = {})
      self.execute("#{@request_domain}#{resource}", "PATCH", params, body, headers)
    end

    # Agrega una entrada al objeto que almacena los headers que se envían en 
    # cada request. Si la clave ingresada ya existe en el objeto, va a sobreescribir 
    # el valor con el recibido.
    def set_header(key, value)
      @default_headers[key] = value
    end

    def set_param(key, value)
      @default_params[key] = value
    end

    def debug(value)
      @debug_mode = value
    end

    def is_404_exception? exception
      return false unless exception.is_a?(RestClient::ExceptionWithResponse)
      return false unless defined?(exception.response.code)
      return exception.response.code == 404
    end

    protected
      def execute url, method = "GET", params = {}, body = nil, headers = {}
        begin
          final_headers = @default_headers.merge(headers)
          final_params = @default_params.merge(params)

          # Sanitizo los value de cada parámetro de URL
          sanitized_params = {}

          final_params.each do |k, v|
            begin
              sanitized_params[k] = URI.escape(v)
            rescue => exception
              sanitized_params[k] = v
            end
          end

          request_args = {
            :url => self.build_url(url, sanitized_params),
            :method => method,
            :headers => final_headers
          }   

          final_body = nil

          if body.present?
            if final_headers[:content_type].present? and final_headers[:content_type] == 'application/json'
              final_body = body.to_json
            else
              final_body = body
            end
          end


          request_args[:payload] = final_body

          # ¿permito certificados auto-firmados?
          unless ssl_verification
            request_args[:verify_ssl] = false
          end

          if debug_mode
            puts "--------------------------------"
            puts "Rest helper debug mode"
            puts "Request args : #{request_args}"

            request_started_at = Time.now
          end

          response = RestClient::Request.execute(request_args)

          if response.body.present?
            return JSON.parse(response.body, symbolize_names: true)
          else
            return true
          end
          
        rescue RestClient::ExceptionWithResponse => exception
          raise exception
        ensure
          if debug_mode
            request_finished_at = Time.now

            puts "Response time : #{request_finished_at - request_started_at} secs"
            puts "Response HTTP code : #{response.code}"
            puts "Response headers : #{response.headers}"
            puts "Response cookies : #{response.cookies}"
            puts "Response payload : #{response.body}"
            puts "--------------------------------"
          end
        end
      end

      def build_url url, params
        if params.present?
          return "#{url}?#{params.to_query}"
        end

        return url
      end
    end
  end
end