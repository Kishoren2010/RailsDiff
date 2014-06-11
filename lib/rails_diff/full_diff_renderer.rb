require 'rails_diff/diff_renderer'

module RailsDiff
  class FullDiffRenderer < DiffRenderer
    DESTINATION = /diff\/[^\/]+\/[^\/]+\/full\/index\.html/
    SOURCE      = ->(t) { t.gsub('full/index.html', 'full.diff') }
    TEMPLATE    = 'templates/full_diff.haml'

    def self.task_definition
      { DESTINATION => [SOURCE, DIRECTORY, LAYOUT, TEMPLATE] }
    end
  end
end
