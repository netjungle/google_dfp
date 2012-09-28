module GoogleDFP
  
  class Engine < ::Rails::Engine
  end
  
  module ViewHelper
    def dfp_tag(name)
      ad = GoogleDFP::Tags.get(name)
      
      width, height = ad['size'].split("x")
      
      style_tag = width.to_i == 800 ? "width: #{width}px; height: auto"  : "width: #{width}px; height: #{height}px"

      content_tag :div,
        "",
        :id    => "dfp-#{name}",
        :class => 'google-dfp',
        :style => style_tag,
        'data-unit' => ad['unit']
    end
  end
  
  module Tags
    
    def self.get(name)
      all[name.to_s] || (raise ArgumentError, "Unknown Google DFP tag: '#{name}'")
    end
    
    def self.all
      @ads ||= YAML.load_file("#{Rails.root}/config/google_dfp.yml")
    end
    
  end
  
end

ActionView::Base.send :include, GoogleDFP::ViewHelper
