class HomeController < ApplicationController
  def index
  end

  def roteiro_orar
    render "home/roteiro_orar/roteiro_orar"
  end

  def footer
  end
end
