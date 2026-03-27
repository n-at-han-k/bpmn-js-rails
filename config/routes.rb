BpmnJsRails::Engine.routes.draw do
  resources :diagrams, path: "processes"
  resources :forms
  resources :decisions
end
