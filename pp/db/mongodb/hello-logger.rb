#! /usr/bin/env ruby -w

# https://docs.mongodb.org/ecosystem/drivers/ruby/
require('logger')

# logger levels
# DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN

logger = Logger.new(STDOUT)
logger.level = Logger::WARN

logger.debug 'Created logger'
logger.info 'Program started'
logger.warn 'Nothing to do!'

path = 'a_non_existent_file'

begin
  File.foreach(path) do |line|
    unless line =~ /^(\w+) = (.*)$/
      logger.error "Line in wrong format: #{line.chomp}"
    end
  end
rescue => err
  logger.fatal 'Caught exception; exiting'
  logger.fatal err
end
