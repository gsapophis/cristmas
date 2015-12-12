# require 'representable/json/collection'
#
# class API::V1::KidsRepresenter < Roar::Decorator
#   include Roar::JSON
#   include Representable::JSON::Collection
#
#   items decorator: API::V1::KidRepresenter
# end

require 'representable/json/collection'

class API::V1::KidsRepresenter < API::BaseCollectionPaginationRepresenter
  include Roar::Contrib::Decorator::CollectionRepresenter
  include Roar::Contrib::Decorator::PageRepresenter

  collection :kids, exec_context: :decorator, decorator: API::V1::KidRepresenter

  def page_url(args)
    api_v1_kids_path(page: args[:page])
  end
end
