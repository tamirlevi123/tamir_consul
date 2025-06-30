class DecisionNodes::InFavorAgainstComponent < ApplicationComponent
  attr_reader :decision_node, :decision_tree
  use_helpers :votes_percentage

  def initialize(decision_node, decision_tree)
    @decision_node = decision_node
    @decision_tree = decision_tree
  end

  private

    def agree_aria_label
      t("votes.agree_label", title: decision_node.content)
    end

    def disagree_aria_label
      t("votes.disagree_label", title: decision_node.content)
    end

    def total_votes
      decision_node.node_votes.count
    end

    def likes_count
      decision_node.node_votes.where(vote_type: 'like').count
    end

    def dislikes_count
      decision_node.node_votes.where(vote_type: 'dislike').count
    end

    def likes_percentage
      return "0%" if total_votes == 0
      "#{(likes_count.to_f * 100 / total_votes).to_i}%"
    end

    def dislikes_percentage
      return "0%" if total_votes == 0
      "#{(dislikes_count.to_f * 100 / total_votes).to_i}%"
    end
end 