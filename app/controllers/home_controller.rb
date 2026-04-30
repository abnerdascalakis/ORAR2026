class HomeController < ApplicationController
  EVENTO_INSCRICAO_URL = "https://eventodaigreja.com.br/O3J4V6"

  def index
  end

  def roteiro_orar
    render "home/roteiro_orar/roteiro_orar"
  end

  def inscricoes
    build_inscricao_form
    @current_step = requested_step if params[:etapa].present?
    render "home/inscricoes/inscricoes"
  end

  def create_inscricao
    build_inscricao_form(inscricao_params)
    selected_modalidades = @selected_modalidade_ids.filter_map { |id| Modalidade.find_by(id: id) }

    validate_inscricao_form(selected_modalidades)

    if @error_messages.any?
      flash.now[:alert] = "Revise os campos obrigatorios antes de finalizar a inscricao."
      return render "home/inscricoes/inscricoes", status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      pessoa = Pessoa.create!(
        nome: @form_data[:nome],
        telefone: @form_data[:telefone],
        sexo_id: @form_data[:sexo_id]
      )

      inscricao = Inscricao.create!(
        pessoa: pessoa,
        sociedade: @sociedade_selecionada
      )

      selected_modalidades.each do |modalidade|
        InscricaoModalidade.create!(inscricao: inscricao, modalidade: modalidade)
      end
    end

    if params[:redirect_to_event].present?
      redirect_to EVENTO_INSCRICAO_URL, allow_other_host: true
    else
      redirect_to inscricoes_path(etapa: 3), notice: "Inscricao realizada com sucesso."
    end
  rescue ActiveRecord::RecordInvalid => e
    @error_messages << e.record.errors.full_messages.to_sentence if e.record.errors.any?
    flash.now[:alert] = "Nao foi possivel concluir a inscricao."
    render "home/inscricoes/inscricoes", status: :unprocessable_entity
  end

  def footer
  end

  private

  def build_inscricao_form(values = {})
    @sexos = Sexo.order(:nome)
    @distritos = Distrito.order(:nome)
    @sociedades = Sociedade.joins(:distrito).includes(:distrito).order("distritos.nome", "sociedades.nome")
    @modalidades = Modalidade.order(:nome)
    @form_data = default_form_data.merge(values.to_h.symbolize_keys)
    hydrate_sociedade_form_data
    @sociedade_selecionada = sociedade_por_busca
    @selected_modalidade_ids = Array(@form_data[:modalidade_ids]).reject(&:blank?).map(&:to_i).uniq
    @error_messages = []
    @current_step = 0
  end

  def default_form_data
    {
      nome: "",
      telefone: "",
      sexo_id: nil,
      distrito_id: nil,
      sociedade_id: nil,
      sociedade_busca: "",
      modalidade_ids: []
    }
  end

  def inscricao_params
    params.require(:inscricao).permit(:nome, :telefone, :sexo_id, :distrito_id, :sociedade_id, :sociedade_busca, modalidade_ids: [])
  end

  def validate_inscricao_form(selected_modalidades)
    participant_errors = []

    participant_errors << "Informe o nome do participante." if @form_data[:nome].blank?
    participant_errors << "Informe o telefone." if @form_data[:telefone].blank?
    participant_errors << "Escolha um sexo." if @form_data[:sexo_id].blank?
    participant_errors << "Escolha um distrito." if @form_data[:distrito_id].blank?
    participant_errors << "Escolha uma sociedade." if @form_data[:sociedade_busca].blank?

    if @form_data[:sexo_id].present? && @sexos.none? { |sexo| sexo.id == @form_data[:sexo_id].to_i }
      participant_errors << "Escolha um sexo valido."
    end

    if @form_data[:distrito_id].present? && @distritos.none? { |distrito| distrito.id == @form_data[:distrito_id].to_i }
      participant_errors << "Escolha um distrito valido."
    end

    if @form_data[:sociedade_busca].present? && @sociedade_selecionada.blank?
      participant_errors << "Escolha uma sociedade valida."
    end

    if @sociedade_selecionada.present? && @form_data[:distrito_id].present? && @sociedade_selecionada.distrito_id != @form_data[:distrito_id].to_i
      participant_errors << "Escolha uma sociedade do distrito selecionado."
    end

    if @form_data[:telefone].present? && !@form_data[:telefone].match?(/\A\(\d{2}\) \d{5}-\d{4}\z/)
      participant_errors << "Informe o telefone no formato (69) 99999-9999."
    end

    @error_messages.concat(participant_errors)
    @current_step = 1 if participant_errors.empty?
    @error_messages << "Selecione ao menos uma modalidade." if selected_modalidades.empty?
  end

  def sociedade_por_busca
    busca = @form_data[:sociedade_busca].to_s.strip
    return Sociedade.find_by(id: @form_data[:sociedade_id]) if @form_data[:sociedade_id].present?

    @sociedades.find { |sociedade| sociedade_label(sociedade) == busca }
  end

  def hydrate_sociedade_form_data
    sociedade = Sociedade.includes(:distrito).find_by(id: @form_data[:sociedade_id])
    return if sociedade.blank?

    @form_data[:sociedade_busca] = sociedade_label(sociedade) if @form_data[:sociedade_busca].blank?
    @form_data[:distrito_id] = sociedade.distrito_id if @form_data[:distrito_id].blank?
  end

  def requested_step
    [[ params[:etapa].to_i - 1, 0 ].max, 2].min
  end

  def sociedade_label(sociedade)
    return "" if sociedade.blank?

    "#{sociedade.nome} - #{sociedade.distrito.nome}"
  end
end
