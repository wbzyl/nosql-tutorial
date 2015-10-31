#! /usr/bin/env ruby -w

# https://docs.mongodb.org/ecosystem/drivers/ruby/
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

logger.debug 'Debug: created logger (low-level info for developers)'
logger.info 'Info: program started'
logger.warn 'Warn: nothing to do!'
logger.error 'Error: a handleable condition occured!'
logger.fatal 'Fatal: unhandleable error that results in a program crash.'
logger.unknown 'Unknown: message that should always be logged.'
