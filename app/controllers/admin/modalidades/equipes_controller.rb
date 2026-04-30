class Admin::Modalidades::EquipesController < Admin::BaseController
  before_action :set_modalidade
  before_action :set_equipe, only: [ :show, :edit, :update, :destroy ]

  def index
    redirect_to admin_modalidade_path(@modalidade)
  end

  def show
    @membro_equipe = @equipe.membro_equipes.build
    @membros = @equipe.membro_equipes
      .joins(inscricao_modalidade: { inscricao: :pessoa })
      .includes(inscricao_modalidade: { inscricao: [ :distrito, { pessoa: :sexo } ] })
      .order("pessoas.nome")

    @q = inscritos_disponiveis.ransack(params[:q])
    inscritos_disponiveis_filtrados = @q.result
      .includes(inscricao: [ :distrito, { pessoa: :sexo } ])
      .order("pessoas.nome")

    @pagy_inscritos_disponiveis, @inscritos_disponiveis = pagy(:offset, inscritos_disponiveis_filtrados, limit: 10)
    @distrito_filtro = Distrito.find_by(id: params.dig(:q, :inscricao_distrito_id_eq))
  end

  def new
    @equipe = @modalidade.equipes.build
  end

  def create
    @equipe = @modalidade.equipes.build(equipe_params)

    if @equipe.save
      redirect_to admin_modalidade_equipe_path(@modalidade, @equipe), notice: "Equipe criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @equipe.update(equipe_params)
      redirect_to admin_modalidade_equipe_path(@modalidade, @equipe), notice: "Equipe atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @equipe.destroy
    redirect_to admin_modalidade_path(@modalidade), notice: "Equipe removida com sucesso."
  end

  private

  def set_modalidade
    @modalidade = Modalidade.find(params[:modalidade_id])
    return if @modalidade.coletiva?

    redirect_to admin_modalidade_path(@modalidade), alert: "Esta modalidade e individual e nao usa equipes."
  end

  def set_equipe
    @equipe = @modalidade.equipes.find(params[:id])
  end

  def equipe_params
    params.require(:equipe).permit(:nome, :distrito_id)
  end

  def inscritos_disponiveis
    @modalidade.inscricao_modalidades
      .joins(inscricao: [ { pessoa: :sexo }, :distrito ])
      .where.not(id: MembroEquipe.select(:inscricao_modalidade_id))
  end
end
