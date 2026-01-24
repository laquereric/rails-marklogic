# Thin Rails service wrapper around marklogic-core

class MarklogicService
  def initialize
    cfg = Rails.application.config.marklogic
    @client = Marklogic::Core::Client.new(
      host: cfg[:host],
      port: cfg[:port],
      username: cfg[:username],
      password: cfg[:password]
    )
  end

  def put_document(uri, body, content_type: "application/xml")
    @client.put_document(uri, body, content_type: content_type)
  end

  def get_document(uri)
    @client.get_document(uri)
  end

  def eval_xquery(xquery, variables: {})
    @client.eval_xquery(xquery, variables: variables)
  end

  def eval_javascript(js, variables: {})
    @client.eval_javascript(js, variables: variables)
  end
end
