module Hound
  class Action < ActiveRecord::Base
    self.table_name = 'hound_actions'

    belongs_to :actionable, polymorphic: true
    belongs_to :user, polymorphic: true

    serialize :changeset, Hash

    scope :created,   -> { where(action: 'create')  }
    scope :updated,   -> { where(action: 'update')  }
    scope :destroyed, -> { where(action: 'destroy') }
  end
end