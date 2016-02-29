Rails.application.routes.draw do

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]



  # The main job of the routes:
  # You map a request to A controller with an action

  # get is a method from Rails routes to help us respond to GET request
  # it takes a hash as a paramter
  get "/hello" => "welcome#index"
  get "/about" => "welcome#about"

  # providing the :as option will give us a route helper method. it will
  # overried the default one if any.
  # Please note that route helpers only loop at the 'path' portion of the route
  # and not the HTTP Verb.
  # Helper methods must be unique
  get "/hello/:name" => "welcome#greet", as: :greet

  get "/subscribe" => "subscribe#index"
  post "/subscribe" => "subscribe#create"

  get "/questions/new" => "questions#new", as: :new_question#(this is a helper method, no need to hardcode)
  post "/questions" => "questions#create", as: :questions#(used more like a collection)

  get "/questions/:id" => "questions#show", as: :question
  get "/questions/:id/edit" => "questions#edit", as: :edit_question
  patch "/questions/:id" => "questions#update"
  delete "/questions/:id" => "questions#destroy"

  # the PATH for this URL (index action) is the same as the PATH for the
  # create action (with POST) so we can just use the one we defined for the
  # create which is 'question_path'
  get "/questions" => "questions#index"
  resources :questions do
    get :search, on: :collection
    patch :mark_done, on: :member
    post :approve


    # By defining `resources :answers` nested inside `resources :questions`
    # Rails will defined all the answers routes prepended with
    # `/questions/:question_id`. This enables us to have the question_id handy
    # so we can create the answer associated with a question with `question_id`
    resources :answers, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
    resources :votes, only: [:create, :update, :destroy]

  end


  # We do this to avoid triple nesting comments under `resources :answers` within
  # the `resources :questions` as it will be very cumbersome to generate routes
  # and use forms. We don't need another set of `answers` routes in here so
  # pass the `only: []` option to it.
  resources :answers, only: [] do
    resources :comments, only: [:create, :destroy]
  end



  resources :users, only: [:create, :new]

resources :sessions, only: [:new, :create, :destroy] do
  delete :destroy, on: :collection
end


resources :favorites, only: [:index]

  # resources :questions#(:questions is related to the questions controller)



  # This will map any Get request iwth path "/hello" to WelcomeController and
  # index action(is a method) within that controller
  # get({"/hello" => "welcome#index"})
                    #value is controller and action
  # Every user request in Rails must be handled by A controller and an action

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # setting the home page of our application to be the quetion listings page
  root 'questions#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
