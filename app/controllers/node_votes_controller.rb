class NodeVotesController < ApplicationController
  skip_authorization_check
  before_action :authenticate_user!
  before_action :set_decision_tree
  before_action :set_decision_node

  def create
    # Atomically destroy an old vote and create a new one.
    @decision_node.node_votes.where(user: current_user).destroy_all
    @vote = @decision_node.node_votes.build(vote_params.merge(user: current_user))

    if @vote.save
      render json: { success: true, votes: get_vote_data_for_node }
    else
      render json: { success: false, error: @vote.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    @vote = @decision_node.node_votes.find_by(user: current_user)
    
    if @vote&.destroy
      render json: { success: true, votes: get_vote_data_for_node }
    else
      render json: { success: false, error: 'Could not find a vote to remove.' }, status: :not_found
    end
  end

  private

  def set_decision_tree
    @decision_tree = DecisionTree.find(params[:decision_tree_id])
  end

  def set_decision_node
    # The node is now consistently found via the decision_node_id from the nested route.
    @decision_node = @decision_tree.decision_nodes.find(params[:decision_node_id])
  end

  def vote_params
    params.require(:node_vote).permit(:vote_type)
  end

  def get_vote_data_for_node
    @decision_node.reload # Ensure vote counts are fresh
    likes = @decision_node.node_votes.where(vote_type: 'like').count
    dislikes = @decision_node.node_votes.where(vote_type: 'dislike').count
    total = likes + dislikes
    
    {
      likes: likes,
      dislikes: dislikes,
      total: total,
      likes_percentage: calculate_percentage(likes, total),
      dislikes_percentage: calculate_percentage(dislikes, total),
      user_vote: @decision_node.node_votes.find_by(user: current_user)&.vote_type
    }
  end

  def calculate_percentage(count, total)
    return "0%" if total == 0
    "#{(count.to_f * 100 / total).round}%"
  end
end 