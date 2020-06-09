class BeachGeneralStatusSerializer < BeachSerializer
  attributes :name
  attribute :sapo_code do |object|
    object.beach_configuration&.sapo_code
  end

  attribute :status do |object|
    case object.status_general&.status
    when 0...3.4
      1
    when 3.4...6.7
      2
    when 6.7...10
      3
    end
  end

  attribute :status_text do |object|
    case object.status_general&.status
    when 0...3.4
      'Ocupação Baixa'
    when 3.4...6.7
      'Ocupação média'
    when 6.7...10
      'Ocupação alta'
    end
  end

  attribute :status_valid_until do |object|
    object.status_general&.valid_until
  end
end
