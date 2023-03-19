module BxBlockAccountGroups
  class GroupsController < ApplicationController
    before_action :find_group, only: [:show, :update, :join_group, :leave_group, :destroy]

    def index
      categories = params[:for_chat] == 'true' ? BxBlockCategories::Category.where.not(name: 'Experience') : BxBlockCategories::Category.all
      render json: BxBlockCategories::CategorySerializer.new(categories, params: { search: params[:search] }).serializable_hash
    end

    def show
      if @group.blank?
        render json: {errors: [{group: "Not found"}]}, status: :not_found
      else
        render json: GroupSerializer.new(@group).serializable_hash, status: :ok
      end
    end

    def create
      category = BxBlockCategories::Category.find_by(name: 'Custom')
      group = Group.new(group_params.merge!(category_id: category.id))
      if group.save
        render json: GroupSerializer.new(group, meta: { message:  'Group successfully created' }).serializable_hash, status: 201
      else
        render json: {errors: group.errors}, status: :unprocessable_entity
      end
    end

    def update
      if @group.update(group_update_params)
        render json: GroupSerializer.new(@group).serializable_hash, status: :ok
      else
        render json: {errors: @group.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      if @group.destroy
        render json: { message: 'Deleted successfully!' }, status: :ok
      else
        render json: {errors: @group.errors}, status: :unprocessable_entity
      end
    end

    def join_group
      if current_user.groups.include?(@group)
        render json: { errors: 'Already a part of group' }, status: 406
      else
        current_user.groups << @group
        render json: GroupSerializer.new(@group).serializable_hash, status: :ok
      end
    end

    def leave_group
      if current_user.groups.include?(@group)
        current_user.groups.delete(@group)
        render json: GroupSerializer.new(@group).serializable_hash, status: :ok
      else
        render json: { errors: 'You are not a member of this group' }, status: 406
      end
    end

    private

    def group_params
      params.require(:group).permit(:name)
    end

    def group_update_params
      params.require(:group).permit(:name, :settings, account_ids: [])
    end

    def find_group
      @group = Group.find_by_id(params[:id])

      unless @group.present?
        render json: {
          errors: [{message: "Group not found"}]
        }, status: :not_found
      end
    end
  end
end
