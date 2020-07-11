Rails.application.routes.draw do
  resources:user do
    resources:genres
    resources:accounts
    resources:account_exchanges
    resources:events
  end

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "homepages#home"
end
