Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'blog/posts#index'

  resources 'feed', only: %i(index)

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  namespace :blog do
    resources :posts, only: %i[index show], concerns: :paginatable
    resources :categories, only: %i[index show]
    resources :tags, only: %i[index show]
  end

  Redirection.all.each do |redirection|
    get redirection.before.to_s => redirect(redirection.after.to_s)
  end
end
