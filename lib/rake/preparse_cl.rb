#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module Rake
  module CLI

    #Allow for a more free form for task arguments
    def preparse_argv!(args = ARGV)
      state = :out
      outer_argv = []
      results = Hash.new {|hash,key| hash[key]=[] }

      args.each do |arg|

        if state == :out
          if arg == '['
            state = :in
          else
            outer_argv << arg
          end
        elsif state == :in
          if arg == ']'
            state = :out
          else
            results[outer_argv.last] << arg
          end
        else
          raise ScriptError, "the author of this method is an idiot"
        end
      end

      args.replace(outer_argv)
      return results
    end

  end
end


