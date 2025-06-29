class DecisionTreesController < ApplicationController
  skip_authorization_check
  before_action :set_decision_tree, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @decision_trees = DecisionTree.all
  end

  def show
    @decision_tree = DecisionTree.find(params[:id])
    @tree_data = @decision_tree.to_json_tree
    @node_ids = @decision_tree.decision_nodes.pluck(:id)
  end

  def new
    @decision_tree = DecisionTree.new
  end

  def create
    @decision_tree = current_user.decision_trees.build(decision_tree_params)
    if @decision_tree.save
      redirect_to @decision_tree, notice: 'Decision tree was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @decision_tree = DecisionTree.find(params[:id])
    
    if @decision_tree.destroy
      redirect_to decision_trees_path, notice: 'Decision tree was successfully deleted.'
    else
      redirect_to @decision_tree, alert: 'Error deleting decision tree.'
    end
  end

  private

  def set_decision_tree
    @decision_tree = DecisionTree.find(params[:id])
  end

  def decision_tree_params
    params.require(:decision_tree).permit(:title, :description)
  end

  def build_tree_data(node, vote_data)
    {
      id: node.id,
      tree_id: @decision_tree.id,
      text: {
        name: sanitize(node.content)
      },
      child_type: node.child_type,
      children: node.child_nodes.map { |child| build_tree_data(child, vote_data) },
      vote_data: vote_data[node.id]
    }
  end

  def collect_node_ids(node)
    [node.id] + node.child_nodes.flat_map { |child| collect_node_ids(child) }
  end

  def sanitize(content)
    ActionController::Base.helpers.sanitize(content)
  end

  def calculate_percentage(part, total)
    return "0%" if total == 0
    "#{(part.to_f / total * 100).round}%"
  end
end 