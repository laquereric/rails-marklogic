class LeannService
  def initialize(client: default_client)
    @client = client
  end

  def get(path, **opts)
    client.get(path, **opts)
  end

  def post(path, payload = {}, **opts)
    client.post(path, payload, **opts)
  end

  private

  attr_reader :client

  def default_client
    Leann::Client.new
  end
end
