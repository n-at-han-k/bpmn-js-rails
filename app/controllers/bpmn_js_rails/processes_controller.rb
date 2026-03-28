module BpmnJsRails
  class ProcessesController < ApplicationController
    before_action :set_process, only: %i[show edit update destroy]

    def index
      @processes = BpmnJsRails::Process.order(updated_at: :desc)
    end

    def show; end

    def new
      @process = BpmnJsRails::Process.new
    end

    def create
      @process = BpmnJsRails::Process.new(process_params)
      if @process.save
        redirect_to @process, notice: "Process was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @process.update(process_params)
        redirect_to @process, notice: "Process was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @process.destroy!
      redirect_to processes_path, notice: "Process was successfully deleted."
    end

    private

    def set_process
      @process = BpmnJsRails::Process.find(params[:id])
    end

    def process_params
      key = params.key?(:process) ? :process : :diagram
      params.require(key).permit(:name, :description, :status, :xml)
    end
  end
end
