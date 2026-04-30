require "pagy"
require "pagy/toolbox/paginators/method"

Pagy::OPTIONS[:limit] = 20
Pagy::I18n.pathnames << Rails.root.join("config/locales/pagy")
