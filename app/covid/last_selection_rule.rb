require_relative './last_selection_question'

class LastSelectionRule
  def process(option)
    option.eql? CovidLastSelectionQuestion::OPT_NINGUNA['id']
  end
end
