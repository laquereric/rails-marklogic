# Core MarkLogic usage examples

class MarklogicController < ApplicationController
  def put_document
    service = MarklogicService.new
    uri = params.require(:uri)
    body = params.require(:body)
    content_type = params[:content_type] || "application/xml"

    service.put_document(uri, body, content_type: content_type)
    render json: { status: "ok", uri: uri }
  end

  def get_document
    service = MarklogicService.new
    uri = params.require(:uri)
    content = service.get_document(uri)
    render plain: content
  end

  def eval_xquery
    service = MarklogicService.new
    xquery = params.require(:xquery)
    result = service.eval_xquery(xquery)
    render plain: result
  end
end
