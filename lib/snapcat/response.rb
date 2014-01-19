module Snapcat
  class Response
    RECOGNIZED_CONTENT_TYPES = %w(application/json application/octet-stream)
    attr_reader :code, :data, :http_success

    def initialize(response, additional_fields = {})
      @data = formatted_result(response).merge(additional_fields)
      @code = response.code
      @http_success = response.success?
    end

    def auth_token
      @data[:auth_token]
    end

    def success?
      if !@data[:logged].nil?
        !!@data[:logged]
      else
        @http_success
      end
    end

    private

    def format_recognized_content(content_type, content)
      if content_type.start_with? 'application/json'
        JSON.parse(content, symbolize_names: true)
      else
        puts "media type: #{content_type}, content: #{content}"
        { media: Media.new(content) }
      end
    end

    def formatted_result(response)
      if !response_empty?(response)
        format_recognized_content(response.content_type, response.body)
      else
        {}
      end
    end

    def response_empty?(response)
      response.body.to_s.empty?
    end
  end
end
