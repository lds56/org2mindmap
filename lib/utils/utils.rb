# Utility
module Utils
  COLOR_ARRAY = %w['RED', 'PINK', 'PURPLE', 'INDIGO', 'BLUE', 'TEAL', 'CYAN',
                 'GREEN', 'LIME', 'YELLOW', 'AMBER', 'ORANGE', 'DEEP_ORANGE']
  @color_index = -1
  @color_reorder = COLOR_ARRAY

  def initialize
  end

  def self.partition_sub(a_para)
    [a_para.slice!(/.+\n/), a_para]
  end

  def self.split_contents(cont, level)
    cont.split(/(?=(?<!\*)\*{#{level}}\s)/)
  end

  def self.init_color(cont)
    group_num = cont.scan(/(?<!\*)\*\s/).length
    @color_reorder = (0..group_num - 1).inject([]) do |tot, i|
      tot + COLOR_ARRAY.select.with_index { |_x, idx| idx % group_num == i }
    end
  end

  def self.get_title(aPara)
    aPara.slice(/[^ \*\n]+/)
  end

  def self.get_level(aLine)
    /(?<star>[*]+)/.match(aLine)[:star].length
  end

  def self.get_text(aLine)
    /\s*(?<text>[^\*\n]+)/.match(aLine)[:text]
  end

  def self.partition_mm(cont)
    meta_data, main_content = cont.split('*', 2)
    [meta_data.split(/(?=#)/), main_content]
  end

  def self.remove_empty_line(cont)
    cont.gsub(/^$\n/, '')
  end

  def self.get_color(color, level)
    if level == 1
      @color_index = (@color_index + 1) % COLOR_ARRAY.length
      @color_reorder[@color_index]
    else
      color
    end
  end

  def self.to_script(var_dict)
    var_dict.map do |d|
      'var ' + d.fetch(:name) + ' = ' + d.fetch(:value) + ";\n"
    end.join
  end
end