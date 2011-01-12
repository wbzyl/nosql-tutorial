require 'gdbm'

movies = GDBM.new("movies.db")

movies.update(
              { "Vertigo" => "Alfred Hitchcock",
                "In a Lonely Place" => "Nicholas Ray",
                "Johnny Guitar" => "Nicholas Ray",
                "Touch of Evil" => "Orson Welles",
                "Psycho" => "Alfred Hitchcock",
              })

movies.close

__END__

# irb session

require "gdbm"

movies = GDBM.new("movies.db")
movies.values.uniq
