class PostsController < ApplicationController
  before_action :set_post, only: %i[edit update destroy]
  before_action :require_login, only: %i[show edit update destroy]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result.includes(:user, :tags).order(created_at: :desc).page(params[:page]).per(9)
  end

  def ranking
    @ranked_posts = Post.includes(:user, :tags).left_joins(:likes).group(:id).order('COUNT(likes.id) DESC').page(params[:page]).per(9)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    tag_list = params[:post][:tag_names].split(',')
  
    if @post.save
      @post.save_tags(tag_list)
      ImageRecognitionJob.perform_later(@post.id)
      redirect_to posts_path, success: '投稿しました'
    else
      flash.now[:danger] = '投稿に失敗しました'
      render :new
    end
  end
  
  def edit; end

  def update
    if @post.update(post_params)
      tag_list = params[:post][:tag_names].split(',')
      @post.save_tags(tag_list)
      redirect_to posts_path, success: '更新しました'
    else
      flash.now[:danger] = '更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_path, success: '削除しました'
  end

  private

  def post_params
    params.require(:post).permit(:image, :description, :tag_names)
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end

end
