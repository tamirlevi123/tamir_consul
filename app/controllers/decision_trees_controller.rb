class DecisionTreesController < ApplicationController
  skip_authorization_check
  before_action :set_decision_tree, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @decision_trees = DecisionTree.all
  end

  def show
    @decision_tree = DecisionTree.find(params[:id])
    @root_node = @decision_tree.root_node
    
    if @root_node
      @tree_data = build_tree_data(@root_node)
      @node_ids = collect_node_ids(@root_node)
    else
      @tree_data = nil
      @node_ids = []
    end
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

  def build_tree_data(node)
    {
      id: node.id,
      text: {
        name: node.content
      },
      children: node.child_nodes.map { |child| build_tree_data(child) }
    }
  end

  def collect_node_ids(node)
    [node.id] + node.child_nodes.flat_map { |child| collect_node_ids(child) }
  end
end 