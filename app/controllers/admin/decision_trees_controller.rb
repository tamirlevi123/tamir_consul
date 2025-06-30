class Admin::DecisionTreesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @decision_trees = DecisionTree.includes(:user, :decision_nodes).order(created_at: :desc)
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

  def destroy
    @decision_tree = DecisionTree.find(params[:id])
    
    if @decision_tree.destroy
      redirect_to admin_decision_trees_path, notice: t("admin.decision_trees.destroy.success_notice")
    else
      redirect_to admin_decision_tree_path(@decision_tree), alert: t("admin.decision_trees.destroy.error_notice")
    end
  end

  private

  def build_tree_data(node)
    {
      id: node.id,
      tree_id: @decision_tree.id,
      text: {
        name: sanitize(node.content)
      },
      children: node.child_nodes.map { |child| build_tree_data(child) }
    }
  end

  def collect_node_ids(node)
    [node.id] + node.child_nodes.flat_map { |child| collect_node_ids(child) }
  end

  def sanitize(content)
    ActionController::Base.helpers.sanitize(content)
  end
end 