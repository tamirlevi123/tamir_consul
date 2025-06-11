class NodeVote < ApplicationRecord
  belongs_to :decision_node
  belongs_to :user
  
  validates :vote_type, presence: true, inclusion: { in: %w[like dislike] }
  validates :user_id, uniqueness: { scope: :decision_node_id }
end
