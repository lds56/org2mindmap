require 'utils/utils'
require 'utils/enumerate'

# basic constructor
module Constructor
  include Enumerable, Utils

  def construct_hasharray(titent)
    Utils.init_color(titent)
    construct_hash_array({ :titent => titent, :color => 'BLACK' }, 1)
  end

  def construct_hash_array(bundle, level)
    title, content = Utils.partition_sub(bundle.fetch(:titent))
    color = bundle.fetch(:color)
    if content.empty?
      [{ :text => Utils.get_text(title), :color => color }]
    else
      sub_contents = Utils.split_contents(content, level)
      child_contents = sub_contents.inject([]) do |tot, sub_content|
        bundle = { :titent => sub_content,
                   :color => Utils.get_color(color, level) }
        tot + construct_hash_array(bundle, level + 1)
      end
      [{ :text => Utils.get_text(title), :color => color,
         :children => child_contents }]
    end
  end

  def construct_metadata(array)
    array.mash do |record|
      /#\+(.+): *(.+)/.match(record)[1, 2]
    end
  end
end