class Admin::Modalidades::Equipes::MembroEquipesController < Admin::BaseController
  before_action :set_modalidade
  before_action :set_equipe

  def create
    membro = @equipe.membro_equipes.build(membro_equipe_params)

    if membro.save
      redirect_to equipe_redirect_url, notice: "Membro adicionado com sucesso.", status: :see_other
    else
      redirect_to equipe_redirect_url, alert: membro.errors.full_messages.to_sentence, status: :see_other
    end
  end

  def destroy
    membro = @equipe.membro_equipes.find(params[:id])
    membro.destroy

    redirect_to equipe_redirect_url, notice: "Membro removido com sucesso.", status: :see_other
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

  def equipe_redirect_url
    referer = url_from(request.referer)
    return admin_modalidade_equipe_path(@modalidade, @equipe, anchor: "gerenciar-membros") if referer.blank?

    uri = URI.parse(referer)
    uri.fragment = "gerenciar-membros"
    uri.to_s
  rescue URI::InvalidURIError
    admin_modalidade_equipe_path(@modalidade, @equipe, anchor: "gerenciar-membros")
  end
end
