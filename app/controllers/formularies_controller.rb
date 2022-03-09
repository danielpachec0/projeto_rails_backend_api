class FormulariesController < ApplicationController
  before_action :set_formulary, only: %i[ show update destroy ]

  # GET /formularies
  def index
    @formularies = Formulary.all

    render json: @formularies
  end

  # GET /formularies/id
  def show
    render json: @formulary
  end

  # POST /formularies
  def create
    @formulary = Formulary.new(formulary_params)

    if @formulary.save
      render json: @formulary, status: :created, location: @formulary
    else
      render json: @formulary.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /formularies/id
  def update
    if @formulary.update(formulary_params)
      render json: @formulary
    else
      render json: @formulary.errors, status: :unprocessable_entity
    end
  end

  # DELETE /formularies/id
  def destroy
    @formulary.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_formulary
      @formulary = Formulary.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def formulary_params
      params.require(:formulary).permit(:name)
    end
end
