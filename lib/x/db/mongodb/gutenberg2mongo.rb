#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

#  Luźne uwagi odnośnie implementacji:
#
#  * W bazie Gutenberg wszystkie pliki, które przeglądałem mają DOSowe
#    końce końce wierszy. W skrypcie ustawiłem to „na sztywno”.
#  * Użycie „bulk save” (czyli wrzucanie tablicy po kawałku) byłoby szybsze.
#  * Przykładowe nagłówki książek w bazie Gutenberg
#
#      preamble:
#
#        *** START OF THIS PROJECT GUTENBERG
#        *** START OF THE PROJECT GUTENBERG
#
#      postamble:
#
#        End of Project Gutenberg's
#        End of the Project Gutenberg
#        End of Project Gutenberg's
#        *** END OF THIS PROJECT GUTENBERG
#        *** END OF THE PROJECT GUTENBERG
#
#    Skrypt szuka tylko takich nagłówków.
#    Starsze książki nie mają takich nagłówków, np. William Shakespeare.
#    albo mają inne – wtedy skrypt nie działa.

require 'rubygems' unless defined? Gem

require 'optparse'
require 'ostruct'

# http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTP.html
require 'net/http'

# http://www.ruby-doc.org/ruby-1.9/classes/Logger.html
require 'logger'

logger = Logger.new(STDERR)
logger.level = Logger::WARN  # set the default level

require 'mongo'

class OptparseGutenberg
  Version = [0, 0, 0]
  #
  # return a structure describing the options
  #
  def self.parse(args)
    # the options specified on the command line will be collected in *options*.

    # set default values
    options = OpenStruct.new
    options.port = 27017
    options.database = "gutenberg"
    options.collection = "books"
    options.recreate = false

    # common options
    options.verbose = false

    opts = OptionParser.new do |opts|
      opts.banner = "Użycie: #{$0} [OPCJE] NAZWA URL"
      opts.separator "---------------------------------------------------------------------------------------"
      opts.separator "  Pobierz z serwera gutenberg.org z URL plik i zapisz go w bieżącym katalogu jako NAZWA"
      opts.separator "  Następnie wczytaj ten plik i po podzieleniu go na akapity"
      opts.separator "  zapisz akapity bazie (default: gutenberg) w kolekcji (default: books)."
      opts.separator "  Akapity krótsze niż 44 znaki są pomijane."
      opts.separator ""
      opts.separator "  Uwaga: Pobierane pliki muszą zawierać PREAMBLE i POSTAMBLE."
      opts.separator ""
      opts.separator "  Przykłady:"
      opts.separator ""
      opts.separator "    #{$0} the-sign-of-the-four.txt http://www.gutenberg.org/cache/epub/2097/pg2097.txt -r -v"
      opts.separator "    #{$0} the-man-who-knew-too-much.txt http://www.gutenberg.org/cache/epub/1720/pg1720.txt -v"
      opts.separator "    #{$0} the-innocence-of-father-brown.txt http://www.gutenberg.org/cache/epub/204/pg204.txt -v"
      opts.separator "    #{$0} the-idiot.txt http://www.gutenberg.org/cache/epub/2638/pg2638.txt"
      opts.separator "    #{$0} memoirs-of-sherlock-holmes.txt http://www.gutenberg.org/cache/epub/834/pg834.txt"
      opts.separator "    #{$0} the-return-of-sherlock-holmes.txt http://www.gutenberg.org/cache/epub/108/pg108.txt"
      opts.separator "    #{$0} the-adventures-of-sherlock-holmes.txt http://www.gutenberg.org/cache/epub/1661/pg1661.txt"
      opts.separator "    #{$0} a-study-in-scarlet.txt http://www.gutenberg.org/cache/epub/244/pg244.txt"
      opts.separator "    #{$0} the-sign-of-the-four.txt http://www.gutenberg.org/cache/epub/2097/pg2097.txt"
      opts.separator "    #{$0} war-and-peace.txt http://www.gutenberg.org/cache/epub/2600/pg2600.txt"
      opts.separator "---------------------------------------------------------------------------------------"
      opts.separator ""

      # cast 'port' argument to a Numeric
      opts.on("-p", "--port N", Numeric, "port na którym uruchomiono MongoDB (27017)") do |n|
        options.port = n
      end

      opts.on("-d", "--database NAZWA", "nazwa bazy danych (gutenberg)") do |name|
        options.database = name
      end

      opts.on("-c", "--collection NAZWA", "nazwa kolekcji w której będą zapisane akapity (books)") do |name|
        options.collection = name
      end

      # boolean switch
      opts.on("-r", "--recreate", "drop database NAZWA") do |r|
        options.recreate = r
      end

      opts.separator ""
      opts.separator "Pozostałe opcje:"
      opts.separator ""

      # no argument, shows at tail
      opts.on_tail("-h", "--help", "wypisz pomoc") do
        puts opts
        exit
      end

      opts.on_tail("--version", "wypisz wersję") do
        puts OptparseGutenberg::Version.join('.')
        exit
      end

      opts.on_tail("-v", "--[no-]verbose", "run verbosely") do |v|
        options.verbose = v
      end

    end

    opts.parse!(args)
    options
  end  # parse()

end  # class OptparseGutenberg

options = OptparseGutenberg.parse(ARGV)

if ARGV.length.odd? || ARGV.length == 0
  puts "Pomoc: #{$0} --help"
  exit
end

logger.level = Logger::INFO if options.verbose

# the Gutenberg part

books = Hash[*ARGV]

books.each do |filename, uri|
  unless File.exists?(filename)
    url = URI.parse(uri)
    req = Net::HTTP::Get.new(url.path)
    logger.info "connecting to gutenberg.org.."
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    logger.info "done: #{res.code}"
    logger.info "writing to #{filename}"
    File.open(filename, 'w') do |f|
      f.write(res.body)
    end
  end
end

# the MongoDB part

connection = Mongo::Connection.new("localhost", options.port)

if options.recreate
   connection.drop_database(options.database)
end

db = connection.db(options.database)
coll = db.collection(options.collection)

count = 0

books.keys.each do |book|

  title = book.split('.')[0].gsub('-', ' ') # usuwamy .txt suffix z nazwy pliku
  data = IO.readlines(book, "\r\n\r\n")     # pliki z dosowymi końcami wierszy

  logger.info "wczytano akapitów: #{data.length}"

  content = data.drop_while do |line|
    line !~ /^(\*\*\* ?)?START OF (THE|THIS) PROJECT/i
  end.reverse.drop_while do |line|
    line !~ /^(\*\*\* ?)?END OF (THE |THIS )?PROJECT GUTENBERG/i
  end.reject do |line|
    line.length < 44 # usuń krótkie akapity
  end.collect do |line|
    line.gsub!(/\r?\n/, ' ').chomp!('  ')
  end.reverse[1..-2]

  logger.info "po usunięciu PRE i POSTAMBLE zapisano w bazie akapitów: #{content.length}"

  content.each do |para|
    coll.insert({
      :paragraph => para,
      :count => count,
      :title => title,
    })
    count += 1
  end

  logger.warn "no paragrpahs found: check if PREAMBLE and POSTAMBLE exists" if content.length == 0

end

logger.info "MongoDB:"
logger.info "\t  database: #{options.database}"
logger.info "\tcollection: #{options.collection} (\##{coll.count})"
