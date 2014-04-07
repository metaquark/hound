class Article < ActiveRecord::Base
  hound(attributes_excluded: [:updated_at])
end
