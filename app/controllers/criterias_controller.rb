class CriteriasController < ApplicationController
  def new
    @criteria = Criteria.new
  end

  def show
    @criteria = Criteria.find(params[:id])
  end

  def create
    @criteria = Criteria.new(criteria_params)

    if @criteria.save
      redirect_to criteria_path(@criteria)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def criteria_params
    params.require(:criteria).permit(public: [], ambiance: [], duree: [], popularite: [])
  end
end
