# frozen_string_literal: true

class DecisionsController < ApplicationController
  before_action :set_decision, only: %i[show edit update destroy]

  def index
    @decisions = BpmnJsRails::Decision.order(updated_at: :desc)
  end

  def show
  end

  def new
    @decision = BpmnJsRails::Decision.new
  end

  def create
    @decision = BpmnJsRails::Decision.new(decision_params)

    if @decision.save
      redirect_to @decision, notice: "Decision was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @decision.update(decision_params)
      redirect_to @decision, notice: "Decision was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @decision.destroy!
    redirect_to decisions_path, notice: "Decision was successfully deleted."
  end

  private

  def set_decision
    @decision = BpmnJsRails::Decision.find(params[:id])
  end

  def decision_params
    params.require(:decision).permit(:name, :description, :status, :xml)
  end
end
