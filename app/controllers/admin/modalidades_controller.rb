class Admin::ModalidadesController < Admin::BaseController
  def index
    @modalidades = Modalidade
      .left_joins(:equipes, :inscricao_modalidades)
      .select("modalidades.*, COUNT(DISTINCT equipes.id) AS equipes_count, COUNT(DISTINCT inscricao_modalidades.id) AS inscricoes_count")
      .group("modalidades.id")
      .order(:nome)
  end

  def show
    @modalidade = Modalidade.find(params[:id])

    if @modalidade.individual?
      inscricao_modalidades = @modalidade.inscricao_modalidades
        .includes(inscricao: [ :distrito, { pessoa: :sexo } ])
        .joins(inscricao: :pessoa)
        .order("pessoas.nome")
      @pagy_inscricao_modalidades, @inscricao_modalidades = pagy(:offset, inscricao_modalidades, limit: 12)

      return
    end

    @equipes = @modalidade.equipes
      .left_joins(:membro_equipes)
      .select("equipes.*, COUNT(membro_equipes.id) AS membros_count")
      .group("equipes.id")
      .order(:nome)
  end
end
