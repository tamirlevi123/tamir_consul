class DecisionNodesController < ApplicationController
  skip_authorization_check
  before_action :authenticate_user!
  before_action :set_decision_tree
  before_action :set_parent_node, only: [:create]

  def create
    @node = @decision_tree.decision_nodes.build(node_params)
    @node.user = current_user
    @node.parent = @parent_node
    @node.position = (@parent_node.child_nodes.maximum(:position) || 0) + 1
    if @node.save
      redirect_to @decision_tree, notice: 'Child node added.'
    else
      Rails.logger.error "Failed to add child node: #{@node.errors.full_messages.join(', ')}"
      Rails.logger.error "Params: #{params.inspect}"
      Rails.logger.error "Parent node: #{@parent_node.inspect}"
      redirect_to @decision_tree, alert: 'Unable to add child node.'
    end
  end

  private

  def set_decision_tree
    @decision_tree = DecisionTree.find(params[:decision_tree_id])
  end

  def set_parent_node
    @parent_node = @decision_tree.decision_nodes.find_by(id: params[:parent_id])
    unless @parent_node
      Rails.logger.error "Parent node not found for id: #{params[:parent_id]} in tree: #{@decision_tree.id}"
    end
  end

  def node_params
    params.require(:decision_node).permit(:content, :url, :url_confirmed)
  end
end 