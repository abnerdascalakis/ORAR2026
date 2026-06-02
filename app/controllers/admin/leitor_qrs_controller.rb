class Admin::LeitorQrsController < Admin::BaseController
  before_action :require_write_access!

  def index
    @refeicoes = current_event.refeicoes.ordenadas
    @operacao = params[:operacao].presence || "presenca"
    @token = params[:token].to_s
    @refeicao_id = params[:refeicao_id].to_s
  end

  def create
    @inscricao = find_inscricao_from_token
    return redirect_to admin_leitor_qr_path, alert: "QR Code invalido ou expirado." if @inscricao.blank?
    return redirect_to admin_leitor_qr_path, alert: "QR Code de outro evento." if @inscricao.evento_id != current_event.id

    case params[:operacao]
    when "alimentacao"
      registrar_consumo_alimentacao
    else
      registrar_presenca
    end
  rescue ActiveRecord::RecordNotUnique
    redirect_to admin_leitor_qr_path(operacao: params[:operacao]), alert: "Esta credencial ja foi usada nesta operacao."
  end

  private

  def find_inscricao_from_token
    token = params[:token].to_s.strip
    token = extract_token_from_url(token) if token.include?("/")

    Inscricao.find_signed(token, purpose: :credencial_evento)
  end

  def extract_token_from_url(raw_token)
    uri = URI.parse(raw_token)
    Rack::Utils.parse_nested_query(uri.query)["token"].presence || uri.path.split("/").last
  rescue URI::InvalidURIError
    raw_token
  end

  def registrar_presenca
    presenca = Presenca.find_or_initialize_by(inscricao: @inscricao, evento: current_event)

    if presenca.persisted?
      redirect_to admin_leitor_qr_path(operacao: "presenca"),
        alert: "#{@inscricao.pessoa.nome} ja teve presenca registrada em #{I18n.l(presenca.registrada_em, format: :short)}."
      return
    end

    presenca.assign_attributes(user: current_user, registrada_em: Time.current)
    presenca.save!

    redirect_to admin_leitor_qr_path(operacao: "presenca"),
      notice: "Presenca registrada para #{@inscricao.pessoa.nome}."
  end

  def registrar_consumo_alimentacao
    refeicao = current_event.refeicoes.find_by(id: params[:refeicao_id])
    return redirect_to admin_leitor_qr_path(operacao: "alimentacao"), alert: "Selecione uma refeicao." if refeicao.blank?

    consumo = ConsumoAlimentacao.find_or_initialize_by(inscricao: @inscricao, refeicao: refeicao)

    if consumo.persisted?
      redirect_to admin_leitor_qr_path(operacao: "alimentacao", refeicao_id: refeicao.id),
        alert: "#{refeicao.nome_com_data} ja foi usada por #{@inscricao.pessoa.nome} em #{I18n.l(consumo.consumido_em, format: :short)}."
      return
    end

    consumo.assign_attributes(user: current_user, consumido_em: Time.current)
    consumo.save!

    redirect_to admin_leitor_qr_path(operacao: "alimentacao", refeicao_id: refeicao.id),
      notice: "#{refeicao.nome_com_data} liberada para #{@inscricao.pessoa.nome}."
  end
end
