Rails.application.routes.draw do
  scope '/core' do
    post 'signin', to: 'core#signin'
    post 'signup', to: 'core#signup'
    post 'forgot-password', to: 'core#forgotPassword'
  end
end
