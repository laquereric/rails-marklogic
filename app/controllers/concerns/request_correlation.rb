module RequestCorrelation
  extend ActiveSupport::Concern

  included do
    before_action :assign_correlation_id
  end

  def assign_correlation_id
    Thread.current[:correlation_id] = request.request_id
  end
end
