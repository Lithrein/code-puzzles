require 'msgpack'

module Utils
  extend self

  def deepcopy tab
    MessagePack.unpack(tab.to_msgpack)
  end
end
