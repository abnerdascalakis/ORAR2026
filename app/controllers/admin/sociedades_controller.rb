class Admin::SociedadesController < Admin::BaseController
  before_action :set_sociedade, only: [ :show, :edit, :update, :destroy ]
  before_action :set_distritos, only: [ :index, :new, :edit, :create, :update ]

  def index
    @q = Sociedade
      .joins(:distrito)
      .includes(:distrito)
      .ransack(params[:q])

    @sociedades = @q.result
      .includes(:distrito)
      .order("distritos.nome", "sociedades.nome")
  end

  def show
  end

  def new
    @sociedade = Sociedade.new
  end

  def create
    @sociedade = Sociedade.new(sociedade_params)

    if @sociedade.save
      redirect_to admin_sociedade_path(@sociedade), notice: "Sociedade criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @sociedade.update(sociedade_params)
      redirect_to admin_sociedade_path(@sociedade), notice: "Sociedade atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sociedade.destroy!
    redirect_to admin_sociedades_path, notice: "Sociedade removida com sucesso."
  rescue ActiveRecord::DeleteRestrictionError, ActiveRecord::InvalidForeignKey
    redirect_to admin_sociedade_path(@sociedade), alert: "Nao foi possivel excluir esta sociedade porque existem inscricoes vinculadas."
  end

  private

  def set_sociedade
    @sociedade = Sociedade.find(params[:id])
  end

  def set_distritos
    @distritos = Distrito.order(:nome)
  end

  def sociedade_params
    params.require(:sociedade).permit(:nome, :distrito_id)
  end
end
