class Admin::DashboardController < Admin::BaseController
  def index
    @stats = [
      { label: "Cadastros", value: "--", hint: "Conecte quando as tabelas estiverem prontas" },
      { label: "Pendencias", value: "--", hint: "Aqui podem entrar itens aguardando revisao" },
      { label: "Atualizacoes", value: "--", hint: "Espaco para sinalizar ultimas alteracoes" }
    ]

    @shortcuts = [
      { title: "Usuarios", description: "Gerencie acessos quando o cadastro estiver definido.", icon: "bi-people" },
      { title: "Inscricoes", description: "Acompanhe fluxo e situacao das inscricoes.", icon: "bi-card-checklist" },
      { title: "Relatorios", description: "Centralize exportacoes, filtros e indicadores.", icon: "bi-graph-up-arrow" }
    ]
  end
end
