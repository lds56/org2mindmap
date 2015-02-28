# array to hash
# provided by Facets' developer
# see it at https://github.com/JuanitoFatas/Ruby-Functional-Programming
module Enumerable
  # def step_enum(n)
  # (n - 1).step(self.size - 1, n).map { |i| self[i] }
  # end
  def mash(&block)
    inject({}) do |output, item|
      key, value = block_given? ? yield(item) : item
      output.merge(key => value)
    end
  end
end