Rails.application.routes.draw do

  post 'web_pages/register'

  get 'web_pages/list'

  get 'web_pages/parse/:id', to: 'web_pages#parse'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
