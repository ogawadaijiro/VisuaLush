class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      flash[:notice] = "コメントしました"
      redirect_to post_path(comment.post)
    else
      flash[:alert] = "コメントに失敗しました"
      redirect_to post_path(comment.post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end
end
