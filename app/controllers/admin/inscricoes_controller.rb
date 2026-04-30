class Admin::InscricoesController < Admin::BaseController
  def index
    @q = Inscricao
      .includes(:modalidades, pessoa: :sexo, sociedade: :distrito)
      .joins(:pessoa, sociedade: :distrito)
      .ransack(params[:q])

    inscricoes = @q.result
      .includes(:modalidades, pessoa: :sexo, sociedade: :distrito)
      .order("pessoas.nome")

    @pagy_inscricoes, @inscricoes = pagy(:offset, inscricoes, limit: 12)
  end
end
