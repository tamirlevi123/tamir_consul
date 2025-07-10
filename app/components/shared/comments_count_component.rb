class Shared::CommentsCountComponent < ApplicationComponent
  attr_reader :comments_count, :url

  def initialize(comments_count, url: nil)
    @comments_count = comments_count
    @url = url
  end

  def text
    t("comments.comment.responses", count: comments_count)
  end
end
