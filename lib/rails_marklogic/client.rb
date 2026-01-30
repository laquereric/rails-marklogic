# frozen_string_literal: true

require "uri"
require "httpclient"

module RailsMarklogic
  class Client
    def initialize(config = RailsMarklogic.configuration)
      @config = config
      @http = HTTPClient.new
      @http.set_auth(config.base_url, config.username, config.password)
      @http.connect_timeout = config.timeout
      @http.send_timeout    = config.timeout
      @http.receive_timeout = config.timeout
    end

    # Store a document. Auto-detects content type from body if not specified.
    #
    #   client.put_document("/users/1.json", '{"name":"Eric"}')
    #   client.put_document("/docs/1.xml", "<doc/>", content_type: "application/xml")
    #   client.put_document("/files/r.pdf", pdf_bytes, content_type: "application/pdf")
    #   client.put_document("/a.json", data, collections: ["users", "active"])
    #
    def put_document(uri, body, content_type: nil, collections: [])
      content_type ||= detect_content_type(body)
      query = build_query(uri, collections: collections)
      res = @http.put("#{@config.base_url}/v1/documents?#{query}", body, { "Content-Type" => content_type })
      handle_response!(res)
      true
    end

    # Retrieve a document by URI. Returns the raw body string.
    #
    #   body = client.get_document("/users/1.json")
    #
    def get_document(uri)
      res = @http.get("#{@config.base_url}/v1/documents?uri=#{encode(uri)}")
      handle_response!(res)
      res.body
    end

    # Delete a document by URI.
    #
    #   client.delete_document("/users/1.json")
    #
    def delete_document(uri)
      res = @http.delete("#{@config.base_url}/v1/documents?uri=#{encode(uri)}")
      handle_response!(res)
      true
    end

    # Execute XQuery on the server.
    #
    #   result = client.eval_xquery('fn:current-dateTime()')
    #   result = client.eval_xquery('declare variable $x external; $x + 1', variables: { x: "41" })
    #
    def eval_xquery(xquery, variables: {})
      eval_code("xquery", xquery, variables)
    end

    # Execute server-side JavaScript.
    #
    #   result = client.eval_javascript('fn.currentDateTime()')
    #
    def eval_javascript(js, variables: {})
      eval_code("javascript", js, variables)
    end

    # Search documents. Accepts a string query or structured JSON query.
    #
    #   results = client.search("keyword")
    #   results = client.search('{"query":{"collection-query":{"uri":["articles"]}}}')
    #
    def search(query, options: {})
      params = { q: query }.merge(options)
      query_string = params.map { |k, v| "#{encode(k.to_s)}=#{encode(v.to_s)}" }.join("&")
      res = @http.get("#{@config.base_url}/v1/search?#{query_string}")
      handle_response!(res)
      res.body
    end

    private

    def eval_code(lang, code, variables)
      payload = { lang => code }
      variables.each { |k, v| payload["vars[#{k}]"] = v.to_s }
      res = @http.post("#{@config.base_url}/v1/eval", payload)
      handle_response!(res)
      res.body.strip
    end

    def handle_response!(res)
      return if res.status >= 200 && res.status < 300

      log_error(res)
      raise Error.from_response(res)
    end

    def log_error(res)
      return unless @config.logger

      @config.logger.error("[RailsMarklogic] HTTP #{res.status}: #{res.body.to_s[0, 500]}")
    end

    def detect_content_type(body)
      str = body.to_s.lstrip
      if str.start_with?("<")
        "application/xml"
      elsif str.start_with?("{", "[")
        "application/json"
      else
        "application/octet-stream"
      end
    end

    def build_query(uri, collections: [])
      parts = ["uri=#{encode(uri)}"]
      collections.each { |c| parts << "collection=#{encode(c)}" }
      parts.join("&")
    end

    def encode(value)
      URI.encode_www_form_component(value.to_s)
    end
  end
end
