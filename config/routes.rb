Rails.application.routes.draw do
  resources :students
  resources :courses do
    resources :enrollments, only: [ :index, :create, :destroy ]
  end
  resource :profile, only: [ :edit, :update ]
  resource :session
  resources :passwords, param: :token

  root "welcome#index"
  get "welcome", to: "welcome#index"

  get "instructor/dashboard", to: "instructor#dashboard", as: :instructor_dashboard
  get "student/dashboard",    to: "student#dashboard",    as: :student_dashboard
end
