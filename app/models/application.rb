class Application
  include Mongoid::Document

  embedded_in :user

  field :activated, type: Boolean, default: false
  field :heroku_id, type: String
  field :last_ping, type: DateTime
  field :name,      type: String
  field :status,    type: String
  field :url,       type: String

  validates :status, allow_nil: true, inclusion: { in: ['up', 'down'] }
end
