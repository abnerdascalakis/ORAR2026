class Admin::Modalidades::Equipes::MembroEquipesController < Admin::BaseController
  before_action :set_modalidade
  before_action :set_equipe

  def create
    membro = @equipe.membro_equipes.build(membro_equipe_params)

    if membro.save
      redirect_to admin_modalidade_equipe_path(@modalidade, @equipe), notice: "Membro adicionado com sucesso."
    else
      redirect_to admin_modalidade_equipe_path(@modalidade, @equipe), alert: membro.errors.full_messages.to_sentence
    end
  end

  def destroy
    membro = @equipe.membro_equipes.find(params[:id])
    membro.destroy

    redirect_to admin_modalidade_equipe_path(@modalidade, @equipe), notice: "Membro removido com sucesso."
  end

  private

  def set_modalidade
    @modalidade = Modalidade.find(params[:modalidade_id])
  end

  def set_equipe
    @equipe = @modalidade.equipes.find(params[:equipe_id])
  end

  def membro_equipe_params
    params.require(:membro_equipe).permit(:inscricao_modalidade_id)
  end
end
