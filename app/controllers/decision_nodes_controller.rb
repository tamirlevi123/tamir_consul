class DecisionNodesController < ApplicationController
  skip_authorization_check
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_decision_tree

  def new
    @decision_node = @decision_tree.decision_nodes.new
  end

  def create
    @decision_node = @decision_tree.decision_nodes.new(decision_node_params)
    @decision_node.user = current_user

    if @decision_node.save
      redirect_to decision_tree_path(@decision_tree), notice: t("decision_nodes.create.success")
    else
      render :new
    end
  end

  private

  def set_decision_tree
    @decision_tree = DecisionTree.find(params[:decision_tree_id])
  end

  def decision_node_params
    params.require(:decision_node).permit(:content, :url, :parent_id, :url_confirmed, :child_type)
  end

  def calculate_percentage(count, total)
    return "0%" if total == 0
    "#{(count.to_f * 100 / total).to_i}%"
  end
end 