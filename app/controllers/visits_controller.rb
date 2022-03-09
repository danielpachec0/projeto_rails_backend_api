class VisitsController < ApplicationController
    before_action :set_visit, only: %i[ show update destroy ]
    
    # GET /visits
    def index
        @visits = Visit.all

        render json: @visits
    end 

    # GET /visits/id
    def show
        render json: @visit
    end

    # POST /visits
    def create
        @visit = Visit.new(visit_params)
    
        if @visit.save
          render json: @visit, status: :created, location: @visit
        else
          render json: @visit.errors, status: :unprocessable_entity
        end
    end

    # PATCH/PUT /visits/id
    def update
        if @visit.update(visit_params)
            render json: @visit
        else
            render json: @visit.errors, status: :unprocessable_entity
        end
    end

    # DELETE /visits/id
    def destroy
        @visit.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_visit
      @visit = Visit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def visit_params
        params.require(:visit).permit(:date, :status, :user_id,:checkin_at, :checkout_at)
    end

end
