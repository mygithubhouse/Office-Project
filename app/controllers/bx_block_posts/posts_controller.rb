# frozen_string_literal: true

module BxBlockPosts
  class PostsController < ApplicationController
    before_action :load_post, only: [:add_comment]
    before_action :load_comment, only: [:delete_comment]

    def index
      posts = if params[:group_ids]&.any?
                Post.includes(:group,
                              account: :groups).where(group_id: params[:group_ids])
              else
                Post.includes(
                  :group, account: :groups
                ).all
              end
      if posts.present?
        render json: PostSerializer.new(posts, meta: { message: 'post listed' }).serializable_hash
      else
        render json: { data: { message: 'No post list available' } }
      end
    end

    def create
      service = current_user.posts.build(post_params)
      if service.save
        render json: PostSerializer.new(service, meta: { message: 'post created succesfully!' }).serializable_hash,
               status: 201
      else
        render json: ErrorSerializer.new(service).serializable_hash, status: :unprocessable_entity
      end
    end

    def show
      post = BxBlockPosts::Post.find_by(id: params[:id])
      if post.blank?
        return render json: { errors: [
          { Post: 'Not found' }
        ] }, status: :not_found
      end
      json_data = PostSerializer.new(post, params: { current_user: current_user }).serializable_hash
      render json: json_data
    end

    def update
      post = BxBlockPosts::Post.find_by(id: params[:id], account_id: current_user.id)

      if post.blank?
        return render json: { errors: [
          { Post: 'Not found' }
        ] }, status: :not_found
      end

      post = BxBlockPosts::Update.new(post, post_params).execute

      if post.persisted?
        render json: PostSerializer.new(post, params: { current_user: current_user }).serializable_hash
      else
        render json: { errors: format_activerecord_errors(post.errors) },
               status: :unprocessable_entity
      end
    end

    def destroy
      post = BxBlockPosts::Post.find_by(id: params[:id], account_id: current_user.id)
      return if post.nil?

      if post.destroy
        render json: { message: 'Post deleted succesfully!' }, status: :ok
      else
        render json: ErrorSerializer.new(post).serializable_hash,
               status: :unprocessable_entity
      end
    end

    def add_comment
      comment = @post.comments.build(comment_params.merge(account_id: current_user.id))
      if comment.save
        render json: BxBlockComments::CommentSerializer.new(comment, meta: { message: 'comment created succesfully!' }).serializable_hash,
               status: 201
      else
        render json: ErrorSerializer.new(comment).serializable_hash, status: :unprocessable_entity
      end
    end

    def delete_comment
      if @comment.destroy
        render json: { message: 'Deleted succesfully!' }, status: 200
      else
        render json: ErrorSerializer.new(@comment).serializable_hash,
               status: :unprocessable_entity
      end
    end

    private

    def post_params
      params.require(:post).permit(:name, :body, :group_id)
    end

    def comment_params
      params.require(:comment).permit(:comment)
    end

    def load_post
      @post = Post.find_by_id(params[:id])

      return if @post.present?

      render json: {
        errors: { message: 'Post not found' }
      }, status: :not_found
    end

    def load_comment
      @comment = BxBlockComments::Comment.find_by_id(params[:comment_id])

      return if @comment.present?

      render json: {
        errors: [{ message: 'Comment not found' }]
      }, status: :not_found
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end
  end
end
