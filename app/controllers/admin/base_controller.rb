class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :authenticate_user!
  before_action :require_admin!

  private

  def require_admin!
    return if current_user&.admin?

    redirect_to root_path, alert: "Voce nao tem permissao para acessar a area administrativa."
  end

  def require_write_access!
    return unless current_user&.read_only_admin?

    redirect_to admin_root_path, alert: "Voce nao tem permissao para alterar dados."
  end

  def current_event
    @current_event ||= Evento.find_by!(descricao: "ORAR 2026")
  end
end
