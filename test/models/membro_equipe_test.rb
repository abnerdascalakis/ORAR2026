require "test_helper"

class MembroEquipeTest < ActiveSupport::TestCase
  test "inscricao modalidade can belong to only one team" do
    sexo = Sexo.create!(nome: "Masculino")
    distrito = Distrito.create!(nome: "Distrito teste")
    evento = Evento.create!(descricao: "Evento teste", ano: 2026)
    pessoa = Pessoa.create!(nome: "Participante teste", telefone: "(69) 99999-9999", sexo: sexo)
    inscricao = Inscricao.create!(pessoa: pessoa, distrito: distrito, evento: evento, adventista: true, estado_civil: "solteiro")
    modalidade = Modalidade.create!(nome: "Modalidade teste", limite: 10)
    inscricao_modalidade = InscricaoModalidade.create!(inscricao: inscricao, modalidade: modalidade)
    primeira_equipe = Equipe.create!(nome: "Equipe A", modalidade: modalidade)
    segunda_equipe = Equipe.create!(nome: "Equipe B", modalidade: modalidade)

    MembroEquipe.create!(equipe: primeira_equipe, inscricao_modalidade: inscricao_modalidade)
    duplicado = MembroEquipe.new(equipe: segunda_equipe, inscricao_modalidade: inscricao_modalidade)

    assert_not duplicado.valid?
    assert duplicado.errors.of_kind?(:inscricao_modalidade_id, :taken)
  end
end
