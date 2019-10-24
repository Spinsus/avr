# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
         path: '',
         path_names: {
           sign_in: 'login',
           sign_out: 'logout',
           registration: 'signup'
         },
         controllers: {
           sessions: 'sessions',
           registrations: 'users'
         }

  resources :recipes, except: :new
  resources :recipe_steps, except: :new
end
