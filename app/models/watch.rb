class Watch < ActiveRecord::Base
  belongs_to :user
  belongs_to :watchable, :polymorphic => true
  
  validates :user_id, :watchable_type, :watchable_id, :presence => true
end
