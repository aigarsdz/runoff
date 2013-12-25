module Runoff
  class SkypeDataFormat
    def get_schema
      if block_given?
        yield :Messages, [:chatname, :timestamp, :from_dispname, :body_xml], ""
      else
        return {
          table: :Messages,
          columns: [:chatname, :timestamp, :from_dispname, :body_xml],
          format_string: ""
        }
      end
    end
  end
end
