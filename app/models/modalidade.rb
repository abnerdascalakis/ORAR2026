class Modalidade < ApplicationRecord
  CATEGORIAS_GENERO = {
    "masculino" => "Masculina",
    "feminino" => "Feminina",
    "misto" => "Mista"
  }.freeze

  has_many :equipes, dependent: :destroy
  has_many :inscricao_modalidades, dependent: :restrict_with_exception
  has_many :inscricoes, through: :inscricao_modalidades

  validates :nome, presence: true
  validates :categoria_genero, inclusion: { in: CATEGORIAS_GENERO.keys }
  validates :limite_membros_por_equipe, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :limite_equipes, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  def self.opcoes_agrupadas
    order(:nome).group_by(&:nome_base).values.map do |modalidades|
      modalidades.find { |modalidade| modalidade.categoria_genero == "misto" } ||
        modalidades.find { |modalidade| modalidade.categoria_genero == "masculino" } ||
        modalidades.first
    end.sort_by(&:nome_base)
  end

  def self.para_sexo(modalidades, sexo)
    categoria = sexo&.nome.to_s.parameterize
    return modalidades unless categoria.in?(%w[masculino feminino])

    modalidades.map do |modalidade|
      next modalidade unless modalidade.genero_especifico?

      find_by(nome: "#{modalidade.nome_base} #{categoria}") || modalidade
    end
  end

  def self.ids_para_opcoes_agrupadas(modalidade_ids)
    modalidades = where(id: modalidade_ids)
    opcoes_por_base = opcoes_agrupadas.index_by(&:nome_base)

    modalidades.filter_map { |modalidade| opcoes_por_base[modalidade.nome_base]&.id }.uniq
  end

  def coletiva?
    !individual?
  end

  def nome_exibicao
    nome_para_exibicao(nome)
  end

  def nome_base
    nome.to_s.sub(/\s+(masculino|feminino)\z/i, "")
  end

  def nome_base_exibicao
    nome_para_exibicao(nome_base)
  end

  def genero_especifico?
    categoria_genero.in?(%w[masculino feminino])
  end

  def tem_categorias_genero?
    return false unless genero_especifico?

    Modalidade.where(categoria_genero: %w[masculino feminino])
      .any? { |modalidade| modalidade.nome_base == nome_base && modalidade.id != id }
  end

  def categoria_genero_label
    CATEGORIAS_GENERO.fetch(categoria_genero)
  end

  def aceita_sexo?(sexo)
    return true if categoria_genero == "misto"

    sexo_nome = sexo&.nome.to_s.parameterize
    sexo_nome == categoria_genero
  end

  private

  def nome_para_exibicao(valor)
    valor.start_with?("Dodgeball") ? valor.sub("Dodgeball", "Dodgeball (queimada)") : valor
  end
end
