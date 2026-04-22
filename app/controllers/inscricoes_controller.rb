class InscricoesController < ApplicationController
  before_action :set_inscricao, only: %i[ show edit update destroy ]
  before_action :load_form_collections, only: %i[ new create edit update ]

  # GET /inscricoes or /inscricoes.json
  def index
    @inscricoes = Inscricao.all
  end

  # GET /inscricaos/1 or /inscricaos/1.json
  def show
  end

  # GET /inscricaos/new
  def new
    @inscricao = Inscricao.new
    @selected_modalidade_ids = []
  end

  # GET /inscricaos/1/edit
  def edit
  end

  # POST /inscricaos or /inscricaos.json
  def create
    @inscricao = Inscricao.new(inscricao_params)
    @selected_modalidade_ids = modalidade_ids

    respond_to do |format|
      if save_inscricao_with_modalidades
        format.html { redirect_to @inscricao, notice: "Inscricao was successfully created." }
        format.json { render :show, status: :created, location: @inscricao }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inscricao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inscricaos/1 or /inscricaos/1.json
  def update
    respond_to do |format|
      if @inscricao.update(inscricao_params)
        format.html { redirect_to @inscricao, notice: "Inscricao was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @inscricao }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inscricao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inscricaos/1 or /inscricaos/1.json
  def destroy
    @inscricao.destroy!

    respond_to do |format|
      format.html { redirect_to inscricaos_path, notice: "Inscricao was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inscricao
      @inscricao = Inscricao.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def inscricao_params
      params.expect(inscricao: [ :nome, :a_sexo_id, :a_distrito_id, :a_sociedade_id ])
    end

    def modalidade_ids
      Array(params.dig(:inscricao, :a_modalidade_ids)).reject(&:blank?).map(&:to_i)
    end

    def load_form_collections
      @sexos = ASexo.order(:nome)
      @distritos = ADistrito.order(:nome)
      @sociedades = ASociedade.order(:nome)
      @modalidades = AModalidade.order(:nome)
    end

    def save_inscricao_with_modalidades
      if @selected_modalidade_ids.empty?
        @inscricao.errors.add(:base, "Selecione ao menos uma modalidade.")
        return false
      end

      Inscricao.transaction do
        @inscricao.save!
        @selected_modalidade_ids.each do |a_modalidade_id|
          @inscricao.inscricao_modalidades.create!(a_modalidade_id: a_modalidade_id)
        end
      end

      true
    rescue ActiveRecord::RecordInvalid
      false
    end
end
