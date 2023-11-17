class ItemsController < ApplicationController

  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
       if user 
        items = user.items
        render json: items, include: :user
       else 
        render_not_found_response
       end
      else 
        items = Item.all
        render json: items, include: :user
    end
  end

  def show
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
       if user 
        item = user.items.find_by(id: params[:id])
        if item
        render json: item, include: :user
       else 
        render_not_found_response
       end
      else 
        render_not_found_response
       end
      else 
        render_not_found_response
    end
  end

  def create
        item = Item.create!(item_params)
          if item.errors.any?
            render_item_creation_failure_response(item.errors.full_messages)
          else
            render json: item, include: :user, status: :created
          end
  end

  private

  def render_not_found_response
    render json: { error: "User not found" }, status: :not_found
  end

  def render_item_creation_failure_response(errors)
    render json: { errors: errors }, status: :unprocessable_entity
  end

  def item_params
    params.permit(:id, :name, :description, :price, :user_id)
  end
end
