require 'representable/json/collection'

class API::BaseCollectionRepresenter < Roar::Decorator
  include Roar::JSON
end
