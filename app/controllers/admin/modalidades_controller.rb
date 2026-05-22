class Admin::ModalidadesController < Admin::BaseController
  def index
    @modalidades = Modalidade
      .left_joins(:equipes, :inscricao_modalidades)
      .select("modalidades.*, COUNT(DISTINCT equipes.id) AS equipes_count, COUNT(DISTINCT inscricao_modalidades.id) AS inscricoes_count")
      .group("modalidades.id")
      .order(:nome)
    @modalidade_grupos = @modalidades.group_by(&:nome_base).map do |nome_base, modalidades|
      variantes = modalidades.sort_by { |modalidade| ordem_categoria_genero(modalidade.categoria_genero) }

      {
        nome_base: nome_base,
        nome_exibicao: variantes.first.nome_base_exibicao,
        individual: variantes.all?(&:individual?),
        inscricoes_count: variantes.sum { |modalidade| modalidade.inscricoes_count.to_i },
        equipes_count: variantes.sum { |modalidade| modalidade.equipes_count.to_i },
        variantes: variantes
      }
    end.sort_by { |grupo| grupo[:nome_base] }
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

  def categorias
    @modalidades = Modalidade
      .left_joins(:equipes, :inscricao_modalidades)
      .select("modalidades.*, COUNT(DISTINCT equipes.id) AS equipes_count, COUNT(DISTINCT inscricao_modalidades.id) AS inscricoes_count")
      .group("modalidades.id")
      .order(:nome)
      .select { |modalidade| modalidade.nome_base == params[:nome_base] }
      .sort_by { |modalidade| ordem_categoria_genero(modalidade.categoria_genero) }

    redirect_to admin_modalidades_path, alert: "Modalidade nao encontrada." and return if @modalidades.empty?
    redirect_to admin_modalidade_path(@modalidades.first) and return if @modalidades.one?

    @nome_exibicao = @modalidades.first.nome_base_exibicao
  end

  private

  def ordem_categoria_genero(categoria_genero)
    { "masculino" => 0, "feminino" => 1, "misto" => 2 }.fetch(categoria_genero, 3)
  end
end
