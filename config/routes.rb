Rails.application.routes.draw do
  get "assessment_items/index"
  get "assessment_items/new"
  get "assessment_items/edit"
  resources :students
  resources :courses do
    resources :enrollments, only: [ :index, :create, :destroy ]
    resources :assessment_items, except: [ :show ]
  end
  resource :profile, only: [ :edit, :update ]
  resource :session
  resources :passwords, param: :token

  root "welcome#index"
  get "welcome", to: "welcome#index"

  get "instructor/dashboard", to: "instructor#dashboard", as: :instructor_dashboard
  get "student/dashboard",    to: "student#dashboard",    as: :student_dashboard
end
