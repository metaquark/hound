class Post < ActiveRecord::Base
  hound actions: 'update', limit: 3
end
