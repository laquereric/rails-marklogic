require "net/http"

module VectorMCP
  module Health
    def self.server_up?(url)
      uri = URI(url)
      Net::HTTP.start(uri.host, uri.port, open_timeout: 1, read_timeout: 1) do |http|
        res = http.get("/")
        res.is_a?(Net::HTTPSuccess) || res.is_a?(Net::HTTPRedirection)
      end
    rescue
      false
    end
  end
end
