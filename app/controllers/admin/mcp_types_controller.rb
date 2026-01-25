module Admin
  class McpTypesController < ApplicationController
    def index
      @types = McpType.order(:name)
    end

    def show
      @type = McpType.find(params[:id])
    end
  end
end
