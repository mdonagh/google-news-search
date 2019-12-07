class SearchTermsController < ApplicationController
  before_action :set_search_term, only: [:show, :edit, :update, :destroy]

  # GET /search_terms
  # GET /search_terms.json
  def index
    @search_terms = SearchTerm.all
  end

  # GET /search_terms/1
  # GET /search_terms/1.json
  def show
    @search_results = @search_term.search_results.order('created_at DESC').paginate(page: params[:page])
  end

  # GET /search_terms/new
  def new
    @search_term = SearchTerm.new
  end

  # GET /search_terms/1/edit
  def edit
  end

  # POST /search_terms
  # POST /search_terms.json
  def create
    @search_term = SearchTerm.new(search_term_params)

    respond_to do |format|
      if @search_term.save
        format.html { redirect_to @search_term, notice: 'Search term was successfully created.' }
        format.json { render :show, status: :created, location: @search_term }
      else
        format.html { render :new }
        format.json { render json: @search_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /search_terms/1
  # PATCH/PUT /search_terms/1.json
  def update
    respond_to do |format|
      if @search_term.update(search_term_params)
        format.html { redirect_to @search_term, notice: 'Search term was successfully updated.' }
        format.json { render :show, status: :ok, location: @search_term }
      else
        format.html { render :edit }
        format.json { render json: @search_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /search_terms/1
  # DELETE /search_terms/1.json
  def destroy
    @search_term.destroy
    respond_to do |format|
      format.html { redirect_to search_terms_url, notice: 'Search term was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search_term
      @search_term = SearchTerm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_term_params
      params.require(:search_term).permit(:term, :timespan, :last_check, :check_frequency)
    end

end
