module MetricAdapter
  class Location
    attr_reader :path, :line
    
    def initialize(combined_path, line = 0)
      @path, @line = parse_path(combined_path || '')
      @line ||= line
    end
    
    def to_s
      "#{path}:#{line}"
    end
    
    def <=>(other)
      [path,line] <=> [other.path, other.line]
    end
    
    private
    
    def parse_path(path)
      path = path.strip
      
      if has_line_number?(path)
        *path_chunks, line = path.split(':')
        [path_chunks.join(':'), line.to_i]
      else
        [path,nil]
      end
    end
    
    def has_line_number?(path)
      !!(path =~ /\:\d+\s*$/)
    end
    
  end
end