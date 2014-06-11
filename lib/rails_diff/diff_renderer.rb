require 'rails_diff/diff_splitter'

module RailsDiff
  class DiffRenderer
    DESTINATION = /diff\/[^\/]+\/[^\/]+\/index\.html/
    DIRECTORY   = ->(t) { t.gsub('/index.html', '') }
    LAYOUT      = 'templates/layout.haml'
    SOURCE      = ->(t) { t.gsub('index.html', 'patch.diff') }
    TEMPLATE    = 'templates/diff.haml'

    def self.from_task(task)
      new(destination: task.name, source: task.source)
    end

    def self.task_definition
      { DESTINATION => [SOURCE, DIRECTORY, LAYOUT, TEMPLATE] }
    end

    def initialize(destination:, file_util: nil, source:)
      @destination = destination
      @file_util   = file_util || File
      @source      = source
    end

    attr_reader :destination
    attr_reader :file_util
    attr_reader :source

    private def diffs
      RailsDiff::DiffSplitter.new(source_content).split
    end

    def generate(template_renderer:)
      output = template_renderer.call(layout: LAYOUT, template: TEMPLATE,
                             locals: {diffs: diffs, title: title})
      file_util.write(destination, output)
    end

    private def source_content
      file_util.read(source)
    end

    private def title
      versions = destination.split('/')[1..2]
      'Rails %s - %s diff' % versions
    end
  end
end
