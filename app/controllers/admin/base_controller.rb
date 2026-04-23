class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :authenticate_user!
  before_action :require_admin!

  private

  def require_admin!
    return if current_user&.admin?

    redirect_to root_path, alert: "Voce nao tem permissao para acessar a area administrativa."
  end
end
