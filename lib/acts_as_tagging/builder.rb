# encoding: utf-8
module ActsAsTagging

  class Builder < ::BasicObject

    def initialize
      @params = {}
    end # new  

    def compile
      @params
    end # compile

    private

    def method_missing(name, *args, &block)

      if [:add].include?(name)
        @params[name] = block 
      end # if

    end # method_missing

  end # Builder

end # ActsAsTagging