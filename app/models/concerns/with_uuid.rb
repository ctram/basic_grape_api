module WithUuid
  extend ActiveSupport::Concern

  REGEX = /^[0-9a-f]{8}-?[0-9a-f]{4}-?[0-9a-f]{4}-?[0-9a-f]{4}-?[0-9a-f]{12}$/

  included do
    validates_presence_of :uuid
    validates_uniqueness_of :uuid

    before_validation :set_uuid, on: :create
    before_create :set_uuid

    private

    # ensures that each new record has a UUID assigned to the 'uuid' field.
    def set_uuid
      self.uuid = SecureRandom.uuid unless uuid =~ REGEX
      true
    end
  end
end
