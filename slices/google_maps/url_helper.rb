module Google
  
  # Provides helpers for various Google map objects when working with urls.
  # This will allow converting to/from encoded url strings when working in rails actions.
  class UrlHelper
    
    # Returns a array of location hashes based on the +encoded_string+ which was encoded using encode_vertices.
    #
    #  encoded_string = "[-33.91,18.48],[-33.93,18.44]"
    #  decoded        = [{:latitude=>"-33.91", :longitude=>"18.48"}, {:latitude=>"-33.93", :longitude=>"18.44"}]
    def self.decode_vertices(encoded_string)
      return [] if encoded_string.blank?
      
      encoded_string.scan(/\[([-\d.]+),([-\d.]+)\]/).collect do |location|
        {:latitude => location[0], :longitude => location[1]}
      end
    end
    
    # Returns a encoded string that represents the +polygons+ vertices. This can then be used in conjunction
    # with eschaton url related methods such as Eschaton#url_for_javascript.
    #
    #  polygon = Google::Polygon.new :vertices =>[{:latitude=>"-33.91", :longitude=>"18.48"}, 
    #                                             {:latitude=>"-33.93", :longitude=>"18.44"}]
    #
    #  Eschaton.url_for_javascript :action => :update_polygon, :vertices => UrlHelper.encode_polygon_vertices(polygon) 
    #  #=> "/update_polygon?vertices=[-33.91,18.48],[-33.93,18.44]"
    def self.encode_vertices(polygon)
      Eschaton.global_script do |script|
        script << "var url_vertices = '';"        
        script << "for(var i = 0; i < #{polygon.vertex_count}; i++){"
        script << "url_vertices += '[' + #{polygon}.getVertex(i).toUrlValue() + '],';"
        script << "}"
        script << "url_vertices = url_vertices.substring(0, url_vertices.length - 1);"        
      end

      '#url_vertices'
    end

    # Encodes the given +location+
    def self.encode_location(location)      
      if location.is_a?(Symbol) || location.is_a?(String)
        {:latitude => "##{location}.lat()", :longitude => "##{location}.lng()"}
      else
        {:latitude => location.latitude, :longitude => location.longitude}
      end
    end

  end
  
end