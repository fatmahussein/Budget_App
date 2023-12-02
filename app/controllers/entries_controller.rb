class EntriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_entry, only: %i[show edit update destroy]

  def index
    if params[:category_id].present?
      category = Category.find(params[:category_id])
      @entries = category.entries.includes(:categories).order(created_at: :desc).where(user_id: current_user.id)
      @total_amount = @entries.sum(:amount)
    else
      @entries = Entry.all.includes(:categories).order(created_at: :desc).where(user_id: current_user.id)
    end
  end

  def show; end

  def new
    @entry = Entry.new
    @entry.categories << Category.find(params[:category_id]) if params[:category_id].present?
    set_categories
  end

  def edit
    set_categories
  end

  def create
    @entry = Entry.new(entry_params)
    @entry.user = current_user
    @categories = Category.all.order(created_at: :desc).where(user_id: current_user.id) unless @entry.save
    respond_to do |format|
      if @entry.save
        if params[:category_id].present?
          format.html do
            redirect_to category_entries_url(params[:category_id]), notice: 'Entry was successfully created.'
          end
        else
          format.html { redirect_to entry_url(@entry), notice: 'Entry was successfully created.' }
        end
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to entry_url(@entry), notice: 'Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @entry.destroy!

    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_entry
    @entry = Entry.find(params[:id])
  end

  def set_categories
    @categories = Category.all.order(created_at: :desc).where(user_id: current_user.id)
  end

  def entry_params
    params.require(:entry).permit(:name, :amount, category_ids: [])
  end
end
