# frozen_string_literal: true

class DiagramsController < ApplicationController
  before_action :set_diagram, only: %i[show edit update destroy]

  def index
    @diagrams = BpmnJsRails::Diagram.order(updated_at: :desc)
  end

  def show
  end

  def new
    @diagram = BpmnJsRails::Diagram.new
  end

  def create
    @diagram = BpmnJsRails::Diagram.new(diagram_params)

    if @diagram.save
      redirect_to @diagram, notice: "Diagram was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @diagram.update(diagram_params)
      redirect_to @diagram, notice: "Diagram was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @diagram.destroy!
    redirect_to diagrams_path, notice: "Diagram was successfully deleted."
  end

  private

  def set_diagram
    @diagram = BpmnJsRails::Diagram.find(params[:id])
  end

  def diagram_params
    params.require(:diagram).permit(:name, :description, :status, :xml)
  end
end
