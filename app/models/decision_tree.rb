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

  def to_json_tree
    root = root_node
    return nil unless root

    nodes = decision_nodes.includes(:node_votes, :user).to_a
    nodes_by_parent_id = nodes.group_by(&:parent_id)
    
    vote_data = nodes.each_with_object({}) do |node, hash|
      likes = node.node_votes.count { |v| v.vote_type == 'like' }
      dislikes = node.node_votes.count { |v| v.vote_type == 'dislike' }
      total = likes + dislikes
      hash[node.id] = {
        likes: likes,
        dislikes: dislikes,
        total: total,
        likes_percentage: calculate_percentage(likes, total),
        dislikes_percentage: calculate_percentage(dislikes, total)
      }
    end

    build_tree_recursively(root, nodes_by_parent_id, vote_data)
  end

  private

  def build_tree_recursively(node, nodes_by_parent_id, vote_data)
    children = (nodes_by_parent_id[node.id] || []).map do |child_node|
      build_tree_recursively(child_node, nodes_by_parent_id, vote_data)
    end.sort_by { |c| c[:child_type] }

    {
      id: node.id,
      tree_id: self.id,
      text: {
        headline: ActionController::Base.helpers.sanitize(node.headline || ""),
        content: ActionController::Base.helpers.sanitize(node.content || "")
      },
      child_type: node.child_type,
      children: children,
      vote_data: vote_data[node.id]
    }
  end

  def calculate_percentage(part, total)
    return "0%" if total == 0
    "#{(part.to_f / total * 100).round}%"
  end

  def create_root_node
    decision_nodes.create!(
      content: title,
      user: user,
      parent_id: nil,
      position: 1
    )
  end
end
