McpUiServer::Engine.routes.draw do
  post "/ui/render", to: "render#create"
  post "/ui/stream", to: "stream#create"
end
