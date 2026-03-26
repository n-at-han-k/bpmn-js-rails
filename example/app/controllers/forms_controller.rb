# frozen_string_literal: true

class FormsController < ApplicationController
  before_action :set_form, only: %i[show edit update destroy]

  def index
    @forms = BpmnJsRails::Form.order(updated_at: :desc)
  end

  def show
  end

  def new
    @form = BpmnJsRails::Form.new
  end

  def create
    @form = BpmnJsRails::Form.new(form_params)

    if @form.save
      redirect_to @form, notice: "Form was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @form.update(form_params)
      redirect_to @form, notice: "Form was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @form.destroy!
    redirect_to forms_path, notice: "Form was successfully deleted."
  end

  private

  def set_form
    @form = BpmnJsRails::Form.find(params[:id])
  end

  def form_params
    params.require(:form).permit(:name, :description, :status).tap do |permitted|
      if params[:form][:schema].present?
        permitted[:schema] = JSON.parse(params[:form][:schema])
      end
    end
  end
end
