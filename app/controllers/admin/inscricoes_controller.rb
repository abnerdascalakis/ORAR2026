class Admin::InscricoesController < Admin::BaseController
  before_action :require_inscricao_actions_access!, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :require_pagamento_access!, only: [ :toggle_pago ]
  before_action :set_inscricao, only: [ :edit, :update, :destroy, :toggle_pago ]
  before_action :set_form_collections, only: [ :new, :create, :edit, :update ]

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
    @return_to = return_to_location
    prepare_edit_form
  end

  def new
    @return_to = admin_inscricoes_path
    @inscricao = Inscricao.new(pago: false)
    @inscricao.build_pessoa
    prepare_edit_form
  end

  def create
    @return_to = admin_inscricoes_path
    @selected_modalidade_ids = selected_modalidade_ids
    @inscricao = Inscricao.new(inscricao_params.merge(evento: current_event))
    @inscricao.build_pessoa(pessoa_params)

    validate_modalidades

    if @error_messages.any?
      prepare_edit_form
      return render :new, status: :unprocessable_entity
    end

    @selected_modalidade_ids = Modalidade.para_sexo(
      @selected_modalidade_ids.filter_map { |id| Modalidade.find_by(id: id) },
      @inscricao.pessoa.sexo
    ).map(&:id)

    ActiveRecord::Base.transaction do
      @inscricao.pessoa.save!
      @inscricao.save!
      sync_modalidades
    end

    redirect_to admin_inscricoes_path, notice: "Inscrição criada com sucesso.", status: :see_other
  rescue ActiveRecord::RecordInvalid => e
    @error_messages << e.record.errors.full_messages.to_sentence if e.record.errors.any?
    prepare_edit_form
    render :new, status: :unprocessable_entity
  end

  def update
    @selected_modalidade_ids = selected_modalidade_ids
    @inscricao.assign_attributes(inscricao_params)
    @inscricao.pessoa.assign_attributes(pessoa_params)

    validate_modalidades

    if @error_messages.any?
      @return_to = return_to_location
      prepare_edit_form
      return render :edit, status: :unprocessable_entity
    end

    @selected_modalidade_ids = Modalidade.para_sexo(
      @selected_modalidade_ids.filter_map { |id| Modalidade.find_by(id: id) },
      @inscricao.pessoa.sexo
    ).map(&:id)

    ActiveRecord::Base.transaction do
      @inscricao.pessoa.save!
      @inscricao.save!
      sync_modalidades
    end

    redirect_to return_to_location, notice: "Inscrição atualizada com sucesso.", status: :see_other
  rescue ActiveRecord::RecordInvalid => e
    @error_messages << e.record.errors.full_messages.to_sentence if e.record.errors.any?
    @return_to = return_to_location
    prepare_edit_form
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @inscricao.destroy!

    redirect_to return_to_location, notice: "Inscrição excluída com sucesso.", status: :see_other
  end

  def toggle_pago
    @inscricao.update!(pago: !@inscricao.pago?)

    status_pagamento = @inscricao.pago? ? "pago" : "nao pago"
    redirect_to return_to_location, notice: "#{@inscricao.pessoa.nome} marcado como #{status_pagamento}.", status: :see_other
  end

  private

  def require_inscricao_actions_access!
    return unless current_user&.distritais? || current_user&.read_only_admin?

    redirect_to admin_inscricoes_path, alert: "Voce nao tem permissao para alterar inscricoes."
  end

  def require_pagamento_access!
    return unless current_user&.distritais? || current_user&.read_only_admin?

    redirect_to admin_inscricoes_path, alert: "Voce nao tem permissao para alterar pagamentos."
  end

  def set_inscricao
    @inscricao = Inscricao
      .includes(:distrito, :modalidades, pessoa: :sexo)
      .find(params[:id])
  end

  def set_form_collections
    @sexos = Sexo.order(:nome)
    @distritos = Distrito.order(:nome)
    @modalidades = Modalidade.opcoes_agrupadas
  end

  def prepare_edit_form
    @error_messages ||= []
    @selected_modalidade_ids ||= Modalidade.ids_para_opcoes_agrupadas(@inscricao.modalidade_ids)
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
    @error_messages << "Informe o nome do participante." if @inscricao.pessoa.nome.blank?
    @error_messages << "Informe o telefone." if @inscricao.pessoa.telefone.blank?
    @error_messages << "Escolha um sexo." if @inscricao.pessoa.sexo_id.blank?
    @error_messages << "Escolha um distrito." if @inscricao.distrito_id.blank?
    @error_messages << "Informe se o participante e adventista." if @inscricao.adventista.nil?
    @error_messages << "Escolha um estado civil." if @inscricao.estado_civil.blank?
    @error_messages << "Selecione ao menos uma modalidade." if @selected_modalidade_ids.empty?

    if @inscricao.pessoa.sexo_id.present? && @sexos.none? { |sexo| sexo.id == @inscricao.pessoa.sexo_id.to_i }
      @error_messages << "Escolha um sexo valido."
    end

    if @inscricao.distrito_id.present? && @distritos.none? { |distrito| distrito.id == @inscricao.distrito_id.to_i }
      @error_messages << "Escolha um distrito valido."
    end

    if @inscricao.estado_civil.present? && !Inscricao::ESTADOS_CIVIS.key?(@inscricao.estado_civil.to_s)
      @error_messages << "Escolha um estado civil valido."
    end

    if @inscricao.pessoa.telefone.present? && !@inscricao.pessoa.telefone.match?(/\A\(\d{2}\) \d{5}-\d{4}\z/)
      @error_messages << "Informe o telefone no formato (69) 99999-9999."
    end

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
    allowed_params = [ :distrito_id, :adventista, :estado_civil ]
    allowed_params << :pago unless current_user&.distritais? || current_user&.read_only_admin?

    params.require(:inscricao).permit(*allowed_params)
  end

  def pessoa_params
    params.require(:inscricao).permit(:nome, :telefone, :sexo_id)
  end

  def return_to_location
    url_from(params[:return_to]).presence || admin_inscricoes_path
  end

  def current_event
    @current_event ||= Evento.find_by!(descricao: "ORAR 2026")
  end
end
