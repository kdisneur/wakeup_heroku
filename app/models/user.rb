class User
  include Mongoid::Document

  embeds_many :applications

  field :api_token,    type: String
  field :email,        type: String
  field :heroku_id,    type: String
end
