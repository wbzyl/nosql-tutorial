#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

#  Luźne uwagi odnośnie implementacji:
#
#  * W bazie Gutenberg wszystkie pliki, które przeglądałem mają DOSowe
#    końce końce wierszy. W skrypcie ustawiłem to „na sztywno”.
#  * Polecenie „bulk save” byłoby szybsze.
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

# require 'rubygems' unless defined? Gem
require 'bundler/setup'

# http://ruby-doc.org/stdlib/libdoc/optparse/rdoc/classes/OptionParser.html
# http://stackoverflow.com/questions/166347/how-do-i-use-ruby-for-shell-scripting

require 'optparse'
require 'ostruct'

require 'pp'

require 'couchrest'

class OptparseGutenberg
  Version = [0, 0, 0]
  #
  # return a structure describing the options
  #
  def self.parse(args)
    # the options specified on the command line will be collected in *options*.

    # set default values
    options = OpenStruct.new
    options.port = 5984
    options.database = "gutenberg"
    options.recreate = false

    # common options
    options.verbose = false

    opts = OptionParser.new do |opts|
      opts.banner = "Użycie: #{$0} [OPCJE] NAZWA TYTUŁ"
      opts.separator ""
      opts.separator "---------------------------------------------------------------"
      opts.separator "  Pobierz z http://www.gutenberg.org/files/ plik NAZWA"
      opts.separator "  i zapisz go w bieżącym katalogu pod nazwą TYTUŁ"
      opts.separator "  Następnie wczytaj plik, podziel go na akapity i zapisz je w bazie CouchDB."
      opts.separator "  (Akapity krótsze niż 80 znaków są pomijane.)"
      opts.separator ""
      opts.separator "  Przykłady (książki muszą zawierać PREAMBLE i POSTAMBLE):"
      opts.separator ""
      opts.separator "    #{$0} --recreate -p 5984 the-sign-of-the-four.txt http://www.gutenberg.org/cache/epub/2097/pg2097.txt"
      opts.separator "    #{$0} -p 5984 the-man-who-knew-too-much.txt http://www.gutenberg.org/cache/epub/1720/pg1720.txt"
      opts.separator "    #{$0} the-innocence-of-father-brown.txt http://www.gutenberg.org/cache/epub/204/pg204.txt"
      opts.separator "    #{$0} the-idiot.txt http://www.gutenberg.org/cache/epub/2638/pg2638.txt"
      opts.separator "    #{$0} memoirs-of-sherlock-holmes.txt http://www.gutenberg.org/cache/epub/834/pg834.txt"
      opts.separator "    #{$0} the-return-of-sherlock-holmes.txt http://www.gutenberg.org/cache/epub/108/pg108.txt"
      opts.separator "    #{$0} the-adventures-of-sherlock-holmes.txt http://www.gutenberg.org/cache/epub/1661/pg1661.txt"
      opts.separator "    #{$0} a-study-in-scarlet.txt http://www.gutenberg.org/cache/epub/244/pg244.txt"
      opts.separator "    #{$0} the-sign-of-the-four.txt http://www.gutenberg.org/cache/epub/2097/pg2097.txt"
      opts.separator "    #{$0} war-and-peace.txt http://www.gutenberg.org/cache/epub/2600/pg2600.txt"
      opts.separator "---------------------------------------------------------------"
      opts.separator ""

      # cast 'port' argument to a Numeric
      opts.on("-p", "--port N", Numeric, "port na którym uruchomiono CouchDB (5984)") do |n|
        options.port = n
      end

      opts.on("-d", "--database NAZWA", "nazwa bazy danych w której bedą zapisane akapity (gutenberg)") do |name|
        options.database = name
      end

      # boolean switch
      opts.on("--recreate", "recreate database NAZWA") do |r|
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
#pp options

if ARGV.length.odd? || ARGV.length == 0
  puts "Pomoc: ./gutenberg2couchdb.rb --help"
  exit
end

# the Gutenberg part

books = Hash[*ARGV]

books.each do |file, url|
  pathfile = File.join(File.dirname(__FILE__), file)
  if options.verbose
    puts "curl #{url} > #{pathfile}"
  end
  `curl #{url} > #{pathfile}` unless File.exists?(pathfile)
end

# the CouchDB part

database = "http://127.0.0.1:#{options.port}/#{options.database}"
#database = "http://sigma.ug.edu.pl:#{options.port}/#{options.database}"
db = CouchRest.database!(database)

if options.recreate
  db.recreate!
end

chunk = 0
books.keys.each do |book|
  title = book.split('.')[0].gsub('-', ' ')
  data = IO.readlines(book, "\r\n\r\n")  # DOS?

  puts "#{title} -- wczytano akapitów: #{data.length}"

  content = data.drop_while do |line|
    line !~ /^(\*\*\* ?)?START OF (THE|THIS) PROJECT/i
  end.reverse.drop_while do |line|
    line !~ /^(\*\*\* ?)?END OF (THE |THIS )?PROJECT GUTENBERG/i
  end.reject do |line|
    line.length < 80 # remove short paragraphs
  end.collect do |line|
    line.gsub!(/\r?\n/, ' ').chomp!('  ')
  end

  puts "po usunięciu PRE i POSTAMBLE zostalo akapitów: #{content.length}"

  content.each do |para|
    db.save_doc({
       :title => title.gsub('-', ' '),
       :chunk => chunk,
       :text => para
    })
    chunk += 1
  end

end

if options.verbose
  puts "database #{database}"
  puts "total para written: #{chunk}"
end
