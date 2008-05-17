ActionController::Routing::Routes.draw do |map|
  map.new_paste '/new', :controller => 'pastes', :action => 'new'
  map.resources :pastes
  map.connect '', :controller => 'pastes', :action => 'index'
end
