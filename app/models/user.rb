class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  DISTRITAIS_EMAIL = "distritais@orar.ro"

  def admin?
    admin
  end

  def distritais?
    email == DISTRITAIS_EMAIL
  end
end
