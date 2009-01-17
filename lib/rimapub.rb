$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rimapub/rimapub.rb'
require 'rimapub/rimapub_service.rb'
require 'rimapub/rimapub_set.rb'

module Rimapub
  VERSION = '0.0.2'
end