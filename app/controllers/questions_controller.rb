class QuestionsController < ApplicationController
  before_action :set_question, only: %i[ show update destroy image ]

  # GET /questions
  def index

    response_data = []
    Question.all.entries.each do |question|
      if question&.image&.attached?
        response_data.append(success_json_with_image(question))
      else 
        response_data.append(question)
      end
    end
    render json: response_data
  end

  # GET /questions/1
  def show

    if @question&.image&.attached?
      render json: success_json_with_image(@question), status: :ok
    else 
      render json: @question
    end
    #render json: @question
    #question = Question.find_by(id: params[:id])
    
  end

  def image
    if @question&.image&.attached?
      redirect_to rails_blob_url(@question.image)
    else
      head :not_found
    end
  end

  # POST /questions
  def create
    @question = Question.new(question_params)
    if @question.save
      render json: @question, status: :created, location: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:name, :question_type, :formulary_id, :image, :text)
    end

    def success_json_with_image(question)
      {
        id: question.id,
        name: question.name,
        created_at: question.created_at,
	      updated_at: question.updated_at,
        formulary_id: question.formulary_id,
        image: rails_blob_url(question.image)
      }
    end
end
