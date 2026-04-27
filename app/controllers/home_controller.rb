class HomeController < ApplicationController
  def index
  end

  def roteiro_orar
    render "home/roteiro_orar/roteiro_orar"
  end

  def inscricoes
    build_inscricao_form
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
        gmail: @form_data[:gmail],
        sexo_id: @form_data[:sexo_id]
      )

      inscricao = Inscricao.create!(
        pessoa: pessoa,
        sociedade_id: @form_data[:sociedade_id]
      )

      selected_modalidades.each do |modalidade|
        InscricaoModalidade.create!(inscricao: inscricao, modalidade: modalidade)
      end
    end

    redirect_to inscricoes_path, notice: "Inscricao realizada com sucesso."
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
    @sociedades = Sociedade.includes(:distrito).order(:nome)
    @modalidades = Modalidade.order(:nome)
    @form_data = default_form_data.merge(values.to_h.symbolize_keys)
    @selected_modalidade_ids = Array(@form_data[:modalidade_ids]).reject(&:blank?).map(&:to_i).uniq
    @error_messages = []
    @current_step = 0
  end

  def default_form_data
    {
      nome: "",
      telefone: "",
      gmail: "",
      sexo_id: nil,
      sociedade_id: nil,
      modalidade_ids: []
    }
  end

  def inscricao_params
    params.require(:inscricao).permit(:nome, :telefone, :gmail, :sexo_id, :sociedade_id, modalidade_ids: [])
  end

  def validate_inscricao_form(selected_modalidades)
    participant_errors = []

    participant_errors << "Informe o nome do participante." if @form_data[:nome].blank?
    participant_errors << "Escolha um sexo." if @form_data[:sexo_id].blank?
    participant_errors << "Escolha uma sociedade." if @form_data[:sociedade_id].blank?

    if @form_data[:sexo_id].present? && @sexos.none? { |sexo| sexo.id == @form_data[:sexo_id].to_i }
      participant_errors << "Escolha um sexo valido."
    end

    if @form_data[:sociedade_id].present? && @sociedades.none? { |sociedade| sociedade.id == @form_data[:sociedade_id].to_i }
      participant_errors << "Escolha uma sociedade valida."
    end

    if @form_data[:gmail].present? && !@form_data[:gmail].match?(URI::MailTo::EMAIL_REGEXP)
      participant_errors << "Informe um e-mail valido."
    end

    @error_messages.concat(participant_errors)
    @current_step = 1 if participant_errors.empty?
    @error_messages << "Selecione ao menos uma modalidade." if selected_modalidades.empty?
  end
end
