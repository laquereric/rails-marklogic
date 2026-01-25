module VectorMCP
  class LeannAdapter
    def initialize(service: LeannService.new)
      @service = service
    end

    def call(method:, path:, payload: nil, **opts)
      case method.to_s.downcase
      when "get"
        service.get(path, **opts)
      when "post"
        service.post(path, payload, **opts)
      else
        raise ArgumentError, "Unsupported method: #{method}"
      end
    end

    private

    attr_reader :service
  end
end
