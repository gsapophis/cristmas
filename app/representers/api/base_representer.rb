require 'representable/json/collection'

class API::BaseRepresenter < Roar::Decorator
  include Roar::JSON
  include Roar::Hypermedia

  def to_hash(options={})
    @options = options
    super
  end

  def options
    @options ||= {}
  end
end
