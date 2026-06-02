class Admin::RefeicoesController < Admin::BaseController
  before_action :require_write_access!, except: [ :index, :show ]
  before_action :set_refeicao, only: [ :show, :edit, :update, :destroy ]

  def index
    @refeicoes = current_event.refeicoes.ordenadas
  end

  def show
    @consumos = @refeicao
      .consumo_alimentacoes
      .includes(:user, inscricao: [ :distrito, { pessoa: :sexo } ])
      .order(consumido_em: :desc)
  end

  def new
    @refeicao = current_event.refeicoes.new
  end

  def create
    @refeicao = current_event.refeicoes.new(refeicao_params)

    if @refeicao.save
      redirect_to admin_refeicao_path(@refeicao), notice: "Refeicao criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @refeicao.update(refeicao_params)
      redirect_to admin_refeicao_path(@refeicao), notice: "Refeicao atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @refeicao.destroy!
    redirect_to admin_refeicoes_path, notice: "Refeicao removida com sucesso."
  rescue ActiveRecord::DeleteRestrictionError, ActiveRecord::InvalidForeignKey
    redirect_to admin_refeicao_path(@refeicao), alert: "Nao foi possivel excluir esta refeicao porque existem consumos vinculados."
  end

  private

  def set_refeicao
    @refeicao = current_event.refeicoes.find(params[:id])
  end

  def refeicao_params
    params.require(:refeicao).permit(:nome, :data, :horario_inicio, :horario_fim)
  end
end
