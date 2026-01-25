module Mcp
  class TypesController < ApplicationController
    def index
      types = McpType.all
      types = types.where(structural_hash: params[:hash]) if params[:hash]
      types = types.where(name: params[:name]) if params[:name]

      render json: types
    end

    def show
      type = McpType.find(params[:id])
      render json: type
    end
  end
end
