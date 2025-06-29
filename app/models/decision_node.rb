class DecisionNode < ApplicationRecord
  belongs_to :decision_tree
  belongs_to :user, optional: true
  has_many :node_votes, dependent: :destroy
  has_many :child_nodes, class_name: 'DecisionNode', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :parent, class_name: 'DecisionNode', optional: true
  
  enum child_type: { ROOT: 0, PRO: 1, CON: 2, NEUTRAL: 3 }

  validates :content, presence: true, unless: -> { url.present? }
  validates :url, format: URI::regexp(%w[http https]), allow_blank: true

  before_create :set_position
  before_create :set_child_type_for_root

  # Only allow saving if url is confirmed (for url nodes)
  def url_confirmation_required?
    if url.present? && !url_confirmed
      errors.add(:url, 'must be confirmed by the user before saving')
    end
  end

  private

  def set_child_type_for_root
    self.child_type = :ROOT if parent_id.nil?
  end

  def set_position
    if parent
      self.position = (parent.child_nodes.maximum(:position) || 0) + 1
    else
      self.position = 1
    end
  end
end
