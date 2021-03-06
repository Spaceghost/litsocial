class Story < ActiveRecord::Base
  has_paper_trail
  attr_accessible :contents, :series_id, :series_position, :title, :remove_from_series
  attr_protected :user_id, :created_at, :updated_at, as: :admin

  acts_as_list column: :series_position, scope: :series
  include Mixins::Lockable

  scope :sorted, order(:id.desc)
  scope :visible, where{ ((deleted == false) | (deleted == nil)) & (locked_at == nil) }
  scope :locked, where{ locked_at != nil }
  scope :deleted, where{ deleted == true }

  belongs_to :series, counter_cache: true
  belongs_to :user

  validates :title, :contents, :user_id, presence: true
  validates :locked_reason, presence: true, if: :locked?
  validates_numericality_of :series_position, :message => "is not a number", allow_blank: true
  validate :series_belongs_to_same_owner_as_story

  attr_accessor :series_title
  before_save :save_series_title, if: ->(o){ o.series_id.blank? && o.series_title }
  before_update :fix_acts_as_list, if: :series_id_changed?

  def visible?
    !(deleted? || locked?)
  end

  def series?
    series_id
  end

  def remove_from_series
    series_id.nil?
  end

  def remove_from_series=(bool)
    return unless bool.to_i == 1
    self.series_id = nil
  end

  protected  
  def fix_acts_as_list
    if series_id
      bottom_position_in_list
    else
      self.series_position = nil
    end
  end

  def save_series_title
    # Need to manually save since the autosave callbacks have already been called.
    self.series_id = user.series.find_or_create_by_title(series_title).try(:id)
  end

  def series_belongs_to_same_owner_as_story
    errors.add :series_id, "Series must belong to the same user" unless series.nil? || series.user == user
  end

end
