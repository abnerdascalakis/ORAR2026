class AModalidadesController < ApplicationController
  before_action :set_a_modalidade, only: %i[ show edit update destroy ]

  # GET /a_modalidades or /a_modalidades.json
  def index
    @a_modalidades = AModalidade.all
  end

  # GET /a_modalidades/1 or /a_modalidades/1.json
  def show
  end

  # GET /a_modalidades/new
  def new
    @a_modalidade = AModalidade.new
  end

  # GET /a_modalidades/1/edit
  def edit
  end

  # POST /a_modalidades or /a_modalidades.json
  def create
    @a_modalidade = AModalidade.new(a_modalidade_params)

    respond_to do |format|
      if @a_modalidade.save
        format.html { redirect_to @a_modalidade, notice: "A modalidade was successfully created." }
        format.json { render :show, status: :created, location: @a_modalidade }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @a_modalidade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /a_modalidades/1 or /a_modalidades/1.json
  def update
    respond_to do |format|
      if @a_modalidade.update(a_modalidade_params)
        format.html { redirect_to @a_modalidade, notice: "A modalidade was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @a_modalidade }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @a_modalidade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /a_modalidades/1 or /a_modalidades/1.json
  def destroy
    @a_modalidade.destroy!

    respond_to do |format|
      format.html { redirect_to a_modalidades_path, notice: "A modalidade was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_a_modalidade
      @a_modalidade = AModalidade.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def a_modalidade_params
      params.expect(a_modalidade: [ :nome, :limite ])
    end
end
