class Admin::PresencasController < Admin::BaseController
  def index
    @distritos = Distrito.order(:nome)
    @nome_filtro = params[:nome].to_s.strip
    @distrito_filtro = Distrito.find_by(id: params[:distrito_id])
    @data_filtro = parse_data_filtro(params[:data])
    @data_referencia = Time.zone.today
    @total_inscricoes = current_event.inscricoes.count
    @total_presencas = current_event.presencas.where(data: @data_referencia).count

    presencas = current_event
      .presencas
      .includes(:user, inscricao: [ :distrito, { pessoa: :sexo } ])
      .joins(inscricao: [ :pessoa, :distrito ])

    if @nome_filtro.present?
      presencas = presencas.where("LOWER(pessoas.nome) LIKE ?", "%#{@nome_filtro.downcase}%")
    end

    if @distrito_filtro.present?
      presencas = presencas.where(inscricoes: { distrito_id: @distrito_filtro.id })
    end

    if @data_filtro.present?
      presencas = presencas.where(data: @data_filtro)
    end

    @pagy_presencas, @presencas = pagy(:offset, presencas.order(registrada_em: :desc), limit: 20)
  end

  private

  def parse_data_filtro(value)
    return if value.blank?

    Date.iso8601(value)
  rescue ArgumentError
    nil
  end
end
