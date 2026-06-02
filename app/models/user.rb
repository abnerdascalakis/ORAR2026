class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  DISTRITAIS_EMAIL = "distritais@orar.ro"
  PASTORES_EMAIL = "pastores@orar.ro"

  def admin?
    admin
  end

  def distritais?
    email == DISTRITAIS_EMAIL
  end

  def pastores?
    email == PASTORES_EMAIL
  end

  def read_only_admin?
    pastores?
  end

  def operador_evento?
    admin? && !read_only_admin?
  end
end
