require 'representable/json/collection'

class API::BaseCollectionPaginationRepresenter < Roar::Decorator
  include Roar::JSON
end
