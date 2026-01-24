module VectorMCP
  module Admin
    class ToolsController < ActionController::Base
      layout "vector_mcp/admin"
      before_action :authorize_admin!
      before_action :ensure_execution_allowed!, only: :execute

      def index
        @tools = VectorMCP::Tools.all
      end

      def show
        tool_hash = VectorMCP::Tools.all.find { |t| t["name"] == params[:id] }
        @tool = VectorMCP::Tool.new(tool_hash, VectorMCP.client)
      end

      def execute
        tool_hash = VectorMCP::Tools.all.find { |t| t["name"] == params[:id] }
        tool = VectorMCP::Tool.new(tool_hash, VectorMCP.client)
        @result = tool.call(**params.require(:args).permit!.to_h)
        render :show
      end

      private

      def ensure_execution_allowed!
        return if Rails.env.development?
        raise ActionController::RoutingError, "Not Found" if VectorMCP.config.admin_read_only
      end

      def authorize_admin!
        if defined?(Pundit)
          authorize :vector_mcp, :admin?
        elsif respond_to?(:authenticate_user!)
          authenticate_user!
        end
      end
    end
  end
end
