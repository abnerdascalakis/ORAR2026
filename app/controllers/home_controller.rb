class HomeController < ApplicationController
  def index
  end

  def roteiro_orar
    render "home/roteiro_orar/roteiro_orar"
  end

  def inscricoes
    render "home/inscricoes/inscricoes"
  end

  def inscricoes_modalidades
    render "home/insc_modalidades/inscricoes_modalidades"
  end

  def footer
  end
end
