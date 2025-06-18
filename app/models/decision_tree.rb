class DecisionTree < ApplicationRecord
  belongs_to :user
  has_many :decision_nodes, dependent: :destroy
  has_many :node_votes, through: :decision_nodes
  
  validates :title, presence: true
  validates :description, presence: true

  after_create :create_root_node

  # Returns the root node of the decision tree (node with no parent)
  def root_node
    decision_nodes.find_by(parent_id: nil)
  end

  private

  def create_root_node
    decision_nodes.create!(
      content: title,
      user: user,
      parent_id: nil,
      position: 1
    )
  end
end
