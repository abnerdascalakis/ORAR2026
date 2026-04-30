require "pagy"
require "pagy/toolbox/paginators/method"

class ApplicationController < ActionController::Base
  include Pagy::Method

  before_action :set_pagy_locale

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protected

  def set_pagy_locale
    Pagy::I18n.locale = I18n.locale
  end

  def after_sign_in_path_for(resource)
    return admin_root_path if resource.respond_to?(:admin?) && resource.admin?

    root_path
  end
end
