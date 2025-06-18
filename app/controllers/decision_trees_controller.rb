class DecisionTreesController < ApplicationController
  skip_authorization_check
  before_action :set_decision_tree, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @decision_trees = DecisionTree.all
  end

  def show
    @root_nodes = @decision_tree.decision_nodes.where(parent_id: nil)
    @tree_json = build_tree_json(@root_nodes.first) if @root_nodes.any? # only build if we have root nodes
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

  private

  def set_decision_tree
    @decision_tree = DecisionTree.find(params[:id])
  end

  def decision_tree_params
    params.require(:decision_tree).permit(:title, :description)
  end

  def build_tree_json(node)
    return unless node
    {
      text: { name: node.content },
      children: node.child_nodes.map { |child| build_tree_json(child) }
    }
  end
end 