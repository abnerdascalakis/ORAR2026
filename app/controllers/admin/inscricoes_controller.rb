class Admin::InscricoesController < Admin::BaseController
  def index
    @q = Inscricao
      .includes(:modalidades, :distrito, pessoa: :sexo)
      .joins(:pessoa, :distrito)
      .ransack(params[:q])

    inscricoes = @q.result
      .includes(:modalidades, :distrito, pessoa: :sexo)
      .order("pessoas.nome")

    @pagy_inscricoes, @inscricoes = pagy(:offset, inscricoes, limit: 12)
  end
end
