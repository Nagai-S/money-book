Rails.application.routes.draw do
  resources:user do
    resources:genres
    resources:accounts
    resources:account_exchanges
    resources:events
    resources:credits
    post "/events1" => "events#create1"
    post "/events2" => "events#create2"
    put "/events_up1/:id" => "events#update1", as: "events_up1"
    put "/events_up2/:id" => "events#update2", as: "events_up2"
  end

  devise_for :users, :controllers => {
   :registrations => 'users/registrations',
   :confirmations => 'users/confirmations',
   :sessions => 'users/sessions',
   :passwords => 'users/passwords'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "homepages#home"
end
