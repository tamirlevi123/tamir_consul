class DecisionNodes::VoteButtonComponent < ApplicationComponent
  attr_reader :decision_node, :decision_tree, :value, :options
  use_helpers :current_user

  def initialize(decision_node, decision_tree, value:, **options)
    @decision_node = decision_node
    @decision_tree = decision_tree
    @value = value
    @options = options
  end

  private

    def path
      if already_voted?
        decision_tree_node_vote_path(decision_tree, decision_node, node_vote)
      else
        decision_tree_node_votes_path(decision_tree, decision_node, node_vote: { vote_type: vote_type })
      end
    end

    def default_options
      if already_voted?
        {
          "aria-pressed": true,
          method: :delete,
          remote: true,
          class: "vote-button #{vote_type}-button voted"
        }
      else
        {
          "aria-pressed": false,
          method: :post,
          remote: true,
          class: "vote-button #{vote_type}-button"
        }
      end
    end

    def node_vote
      @node_vote ||= NodeVote.find_or_initialize_by(
        decision_node: decision_node, 
        user: current_user, 
        vote_type: vote_type
      )
    end

    def already_voted?
      node_vote.persisted?
    end

    def vote_type
      value == "yes" ? "like" : "dislike"
    end

    def icon_class
      value == "yes" ? "fa-thumbs-up" : "fa-thumbs-down"
    end

    def button_text
      value == "yes" ? "👍" : "👎"
    end
end 