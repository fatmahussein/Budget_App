class CategoriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @entries_available = false
    if Entry.all.where(user_id: current_user.id).empty?
      @categories = Category.all.order(created_at: :desc).where(user_id: current_user.id)
    else
      @entries_available = true
      @categories = Category.all.includes(:entries).order(created_at: :desc).where(user_id: current_user.id)
    end
  end

  def show
    @entries_available = false
    if Entry.all.where(user_id: current_user.id).empty?
      @entries = []
    else
      @entries_available = true
      @entries = Category.find(params[:id]).entries.order(created_at: :desc).where(user_id: current_user.id)
    end
  end

  def new
    @category = Category.new
    set_icons
  end

  def edit
    set_icons
  end

  def create
    @category = Category.new(category_params)
    @category.user = current_user
    set_icons unless @category.save
    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_url, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to category_url(@category), notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @category.destroy!

    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def set_icons
    @icons = ['🍟', '🏛️', '🍴', '🏠', '🏫', '🗑️', '🧾', '💰', '🍹', '✈️', '🚗', '🚇']
  end

  def category_params
    params.require(:category).permit(:name, :icon, :user_id)
  end
end
