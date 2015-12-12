require 'representable/json/collection'

class API::V1::KidsRepresenter < Roar::Decorator
  include Roar::JSON
  include Representable::JSON::Collection

  items decorator: API::V1::KidRepresenter
end
