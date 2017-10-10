class ReviewsController < ApplicationController
  before_action only: [:edit, :update, :destroy] do
    find_review current_user.reviews
  end
  before_action only: :show do
    find_review Review.all
  end

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all.page(params[:page])
                            .per 10
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # POST /reviews
  # POST /reviews.json
  def create
    review = Review.new review_params
    review.title = "Review created at: %s" % Date.current.to_s
    review.content =""
    #if game table nil -> false
    review.game = Game.first
    if review.save
      redirect_to edit_review_path review
    else
      redirect_to reviews_path
    end
  end

  # GET /reviews/1/edit
  def edit
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def review_params
    params.require(:review).permit :user_id, :content, :title, :game_id, :photo
  end

  def find_review review
    @review = review.find_by id: params[:id]
    redirect_to review_root_path unless @review
  end
end
