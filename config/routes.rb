Rails.application.routes.draw do
  devise_for :users
  
  resources :project do 
    resources :screens
  end

  resources :user


  root to: "static_page#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
