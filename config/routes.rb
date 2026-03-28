BpmnJsRails::Engine.routes.draw do
  resources :processes
  resources :forms
  resources :decisions
end
