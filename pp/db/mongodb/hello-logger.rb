#! /usr/bin/env ruby -w

# rubocop:disable Metrics/LineLength

# https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/50-debugging/lessons/123-ruby_logging
require('logger')

# logger levels
# DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN

levels = {
  debug: Logger::DEBUG,
  info: Logger::INFO,
  warn: Logger::WARN,
  error: Logger::ERROR,
  fatal: Logger::FATAL,
  unknown: Logger::UNKNOWN
}

logger = Logger.new($stdout)

# set default level to Logger::INFO
level = levels[ARGV[0].to_s.downcase.to_sym] || Logger::INFO
logger.level = level

logger.debug 'low-level info for developers: Created logger'
logger.info 'generic information about system operation: Program started'
logger.warn 'a warning: Nothing to do!'
logger.error 'a handleable condition: Line in wrong format!'
logger.fatal 'an unhandleable error that results in a program crash: Program crashed'
logger.unknown 'something unknown: This can’t happen!'
