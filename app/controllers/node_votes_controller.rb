class NodeVotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_decision_tree
  before_action :set_decision_node

  def create
    @vote = @decision_node.node_votes.build(vote_params)
    @vote.user = current_user

    if @vote.save
      redirect_to @decision_tree, notice: 'Vote recorded successfully.'
    else
      redirect_to @decision_tree, alert: 'Unable to record vote.'
    end
  end

  private

  def set_decision_tree
    @decision_tree = DecisionTree.find(params[:decision_tree_id])
  end

  def set_decision_node
    @decision_node = @decision_tree.decision_nodes.find(params[:decision_node_id])
  end

  def vote_params
    params.require(:node_vote).permit(:vote_type)
  end
end 