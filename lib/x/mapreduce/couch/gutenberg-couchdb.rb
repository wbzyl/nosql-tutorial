#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# TODO:
#  * skrypt działa tylko z ruby 1.9.2
#  * zakładam dosowe końce wierszy w pobranych plikach
#  * bulk save byłoby szybsze

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
      opts.banner = "Użycie: gutenberg-couchdb.rb [OPCJE] NAZWA TYTUŁ"
      opts.separator ""
      opts.separator "---------------------------------------------------------------"
      opts.separator "  Pobierz z http://www.gutenberg.org/files/ plik NAZWA"
      opts.separator "  i zapisz go w bieżącym katalogu pod nazwą TYTUŁ"
      opts.separator "  Następnie wczytaj plik, podziel go na akapity i zapisz je w bazie CouchDB."
      opts.separator "  (Akapity krótsze niż 128 znaków są pomijane.)"
      opts.separator ""
      opts.separator "  Przykłady:"
      opts.separator ""
      opts.separator "    gutenberg-couchdb.rb --recreate -p 4000 the-sign-of-the-four.txt 2097/2097.txt"
      opts.separator ""
      opts.separator "    gutenberg-couchdb.rb -p 4000 -v \\"
      opts.separator "      memoirs-of-sherlock-holmes.txt 834/834.txt\\"
      opts.separator "      the-return-of-sherlock-holmes.txt 221/221.txt"

      opts.separator "---------------------------------------------------------------"
      opts.separator ""

      # cast 'port' argument to a Numeric
      opts.on("-p", "--port N", Numeric, "port na którym uruchomiono CouchDB (5984)") do |n|
        options.port = n
      end

      opts.on("-d", "--database NAZWA", "nazwa bazy danych w której bedą zapisane akapity") do |name|
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
  puts "Pomoc: gutenberg.rb --help"
  exit
end

# the Gutenberg part

gutenberg_files = 'http://www.gutenberg.org/files'

books = Hash[*ARGV]

# testing ..
#books = {
#  'the-sign-of-the-four.txt' => '2097/2097.txt'
#  'the-sign-of-the-four.txt' => '2097/2097.txt',
#  'the-hound-of-the-baskervilles.txt' => '2852/2852.txt',
#  'the-valley-of-fear.txt' => '3289/3289.txt',
#  'a-study-in-scarlet.txt' => '244/244.txt',
#  'memoirs-of-sherlock-holmes.txt' => '834/834.txt',
#  'the-return-of-sherlock-holmes.txt' => '221/221.txt'
#}

books.each do |file, url|
  pathfile = File.join(File.dirname(__FILE__), file)
  if options.verbose
    puts "curl #{gutenberg_files}/#{url} > #{pathfile}"
  end
  `curl #{gutenberg_files}/#{url} > #{pathfile}` unless File.exists?(pathfile)
end

# the CouchDB part

database = "http://127.0.0.1:#{options.port}/#{options.database}"
db = CouchRest.database!(database)

if options.recreate
  db.recreate!
end

chunk = 0
books.keys.each do |book|
  title = book.split('.')[0].gsub('-', ' ')
  data = IO.readlines(book, "\r\n\r\n")  # DOS?

  content = data.drop_while do |line|
    line !~ /^\*\*\* START OF THIS PROJECT GUTENBERG EBOOK /
  end.reverse.drop_while do |line|
    line !~ /^\*\*\* END OF THIS PROJECT GUTENBERG EBOOK /
  end.reject do |line|
    line.length < 128 # remove short paragraphs
  end.collect do |line|
    line.gsub!(/\r?\n/, ' ').chomp!('  ')
  end

  content.each do |para|
    db.save_doc({
      :title => title.gsub('-', ' '),
      :chunk => chunk,
      :text => para
    })
    chunk += 1
  end

  if options.verbose
    puts "title: #{title}"
    puts "total para so far: #{chunk}"
  end

end

if options.verbose
  puts "database #{database}"
  puts "total para written: #{chunk}"
end
