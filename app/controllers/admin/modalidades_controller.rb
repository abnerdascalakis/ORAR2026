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
    @equipes = @modalidade.equipes
      .left_joins(:membro_equipes)
      .select("equipes.*, COUNT(membro_equipes.id) AS membros_count")
      .group("equipes.id")
      .order(:nome)
  end
end
