class DecisionTree < ApplicationRecord
  belongs_to :user
  has_many :decision_nodes, dependent: :destroy
  has_many :node_votes, through: :decision_nodes
  
  validates :title, presence: true
  validates :description, presence: true
end
