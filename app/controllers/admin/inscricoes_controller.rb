class Admin::InscricoesController < Admin::BaseController
  before_action :set_inscricao, only: [ :edit, :update, :destroy ]
  before_action :set_form_collections, only: [ :edit, :update ]

  def index
    @q = Inscricao
      .includes(:modalidades, :distrito, pessoa: :sexo)
      .joins(:pessoa, :distrito)
      .ransack(params[:q])
    @distrito_filtro = Distrito.find_by(id: params.dig(:q, :distrito_id_eq))

    inscricoes = @q.result
      .includes(:modalidades, :distrito, pessoa: :sexo)
      .order("pessoas.nome")

    @pagy_inscricoes, @inscricoes = pagy(:offset, inscricoes, limit: 12)
  end

  def edit
    prepare_edit_form
  end

  def update
    @selected_modalidade_ids = selected_modalidade_ids
    @inscricao.assign_attributes(inscricao_params)
    @inscricao.pessoa.assign_attributes(pessoa_params)

    validate_modalidades

    if @error_messages.any?
      prepare_edit_form
      return render :edit, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      @inscricao.pessoa.save!
      @inscricao.save!
      sync_modalidades
    end

    redirect_to admin_inscricoes_path, notice: "Inscrição atualizada com sucesso."
  rescue ActiveRecord::RecordInvalid => e
    @error_messages << e.record.errors.full_messages.to_sentence if e.record.errors.any?
    prepare_edit_form
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @inscricao.destroy!

    redirect_to admin_inscricoes_path, notice: "Inscrição excluída com sucesso."
  end

  private

  def set_inscricao
    @inscricao = Inscricao
      .includes(:distrito, :modalidades, pessoa: :sexo)
      .find(params[:id])
  end

  def set_form_collections
    @sexos = Sexo.order(:nome)
    @distritos = Distrito.order(:nome)
    @modalidades = Modalidade.order(:nome)
  end

  def prepare_edit_form
    @error_messages ||= []
    @selected_modalidade_ids ||= @inscricao.modalidade_ids
    @distrito_filtro = Distrito.find_by(id: @inscricao.distrito_id)
    @inscricao_modalidades_com_equipes = @inscricao
      .inscricao_modalidades
      .includes(:modalidade, membro_equipes: :equipe)
      .select { |inscricao_modalidade| inscricao_modalidade.membro_equipes.any? }
  end

  def selected_modalidade_ids
    Array(params.dig(:inscricao, :modalidade_ids)).reject(&:blank?).map(&:to_i).uniq
  end

  def validate_modalidades
    @error_messages = []
    @error_messages << "Selecione ao menos uma modalidade." if @selected_modalidade_ids.empty?

    modalidade_ids_existentes = @modalidades.select { |modalidade| @selected_modalidade_ids.include?(modalidade.id) }.map(&:id)
    return if (@selected_modalidade_ids - modalidade_ids_existentes).empty?

    @error_messages << "Selecione apenas modalidades validas."
  end

  def sync_modalidades
    modalidade_ids_atuais = @inscricao.inscricao_modalidades.pluck(:modalidade_id)
    modalidade_ids_removidas = modalidade_ids_atuais - @selected_modalidade_ids
    modalidade_ids_adicionadas = @selected_modalidade_ids - modalidade_ids_atuais

    @inscricao.inscricao_modalidades.where(modalidade_id: modalidade_ids_removidas).find_each(&:destroy!)

    modalidade_ids_adicionadas.each do |modalidade_id|
      @inscricao.inscricao_modalidades.create!(modalidade_id: modalidade_id)
    end
  end

  def inscricao_params
    params.require(:inscricao).permit(:distrito_id, :adventista, :estado_civil)
  end

  def pessoa_params
    params.require(:inscricao).permit(:nome, :telefone, :sexo_id)
  end
end
