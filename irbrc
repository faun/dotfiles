#!/usr/bin/ruby

require 'irb/completion'
require 'rubygems'

begin
  require "pry"
  Pry.start
  exit
rescue LoadError
  puts "=> Unable to load pry"
end

begin
  require 'awesome_print'
  AwesomePrint.irb!
rescue LoadError, ActiveSupport::DeprecationException
  puts "=> Unable to load awesome_print"
end

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:USE_READLINE] = true

IRB.conf[:AUTO_INDENT] = true

# don't save duplicates
IRB.conf[:AT_EXIT].unshift Proc.new {
    no_dups = []
    Readline::HISTORY.each_with_index { |e,i|
        begin
            no_dups << e if Readline::HISTORY[i] != Readline::HISTORY[i+1]
        rescue IndexError
        end
    }
    Readline::HISTORY.clear
    no_dups.each { |e|
        Readline::HISTORY.push e
    }
}

class Object
  # list methods which aren't in superclass
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end

  # print documentation
  #
  #   ri 'Array#pop'
  #   Array.ri
  #   Array.ri :pop
  #   arr.ri :pop
  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    puts `ri '#{method}'`
  end
end

def copy(str)
  IO.popen('pbcopy', 'w') { |f| f << str.to_s }
end

def paste
  `pbpaste`
end

# Show SQL in console
# if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
#   require 'logger'
#   RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
# end

# From: https://github.com/lucapette/dotfiles/blob/master/irbrc
# method the return the methods not present on basic objects, good for
# investigations
class Object
    def interesting_methods
        (self.methods - Object.instance_methods).sort
    end
end

# toys methods to play with.
# Stealed from https://gist.github.com/807492
class Array
    def self.toy(n=10,&block)
        block_given? ? Array.new(n,&block) : Array.new(n) {|i| i+1}
    end
end

class Hash
    def self.toy(n=10)
        Hash[Array.toy(n).zip(Array.toy(n){|c| (96+(c+1)).chr})]
    end
end


# detects a rails console, cares about version
def rails?(*args)
    version=args.first
    v2 = ($0 == 'irb' && ENV['RAILS_ENV'])
    v3 = ($0 == 'script/rails' && Rails.env)
    version == 2 ? v2 : version == 3 ? v3 : v2 || v3
end

# loading rails configuration if it is running as a rails console
load File.dirname(__FILE__) + '/.railsrc' if rails?
