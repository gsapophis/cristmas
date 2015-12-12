class API::V1::KidRepresenter < API::BaseRepresenter
  property :id

  link :self do
    api_v1_kid_url represented
  end
end
