AchImport::Application.routes.draw do
  get "result", :to => "home#result"
  get "download", :to => "home#download"
  root :to => "home#index"
end
