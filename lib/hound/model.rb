module Hound
  module Model

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      # Tell Hound to track this models actions.
      #
      # options - a Hash of configuration options (default: {}).
      #           :limit   - An Integer limit to restrict the maximum actions
      #                      stored (optional, default: nil (no limit)).
      #           :actions - An Array of actions to track.
      #                      (default: [:create, :update, :destroy])
      #           :attributes_excluded - An Array of attributes to exclude from tracking.
      #                      (default: [])
      def hound(options = {})
        send :include, InstanceMethods

        has_many :actions, as: :actionable, class_name: 'Hound::Action'

        options[:actions] ||= Hound.config.actions
        options[:actions] = Array(options[:actions]).map(&:to_s)

        options[:attributes_excluded] ||= []

        class_attribute :hound_options
        self.hound_options = options.dup

        attr_accessor :hound

        # Add action hooks
        after_create :hound_create, if: :hound? if options[:actions].include?('create')
        before_update :hound_update, if: :hound? if options[:actions].include?('update')
        after_destroy :hound_destroy, if: :hound? if options[:actions].include?('destroy')
      end

      def hound_user(options = {})
        has_many :actions, as: :user, class_name: 'Hound::Action'
      end
    end

    module InstanceMethods

      # Return all actions in provided date.
      def actions_for_date(date)
        actions.where(created_at: date)
      end

      # Returns true if hound is enabled on this instance.
      def hound?
        hound != false
      end

      private

      def hound_create
        create_action(action: 'create')
      end

      def hound_update
        changeset = changes.except *self.class.hound_options[:attributes_excluded]
        return if changeset.size == 0
        create_action(action: 'update', changeset: changeset)
      end

      def hound_destroy
        create_action({action: 'destroy'}, false)
      end

      def create_action(attributes, scoped = true)
        attributes = default_attributes.merge(attributes)
        if scoped
          actions.create!(attributes)
        else
          # unscoped actions should still always save the associated data
          Hound.actions.create(attributes.merge({
            actionable_id: self.id,
            actionable_type: self.class.base_class.name
          }))
        end
        enforce_limit
      end

      def default_attributes
        {
          user_id: Hound.store[:current_user_id],
          user_type: Hound.store[:current_user_type],
        }
      end

      def enforce_limit
        limit = self.class.hound_options[:limit]
        limit ||= Hound.config.limit
        if limit and actions.size > limit
          good_actions = actions.order('created_at DESC').limit(limit)
          actions.where('id NOT IN (?)', good_actions.map(&:id)).delete_all
        end
      end

    end

  end
end