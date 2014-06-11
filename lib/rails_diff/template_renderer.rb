class TemplateRenderer
  def initialize
    @templates = {}
  end

  def call(layout:, locals:, template:)
    locals[:title] ||= nil

    fetch_template(layout).render(nil, locals) do
      fetch_template(template).render(nil, locals)
    end
  end

  private def fetch_template(name)
    @templates.fetch(name) do |name|
      template = Haml::Engine.new(File.read(name))
      @templates[name] = template
      template
    end
  end
end
