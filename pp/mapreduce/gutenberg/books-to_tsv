#! /bin/env ruby

def to_tsv(file_name, title, author, pre, post)
  lines = IO.readlines(file_name)
  text = lines[pre...-post].join()
  paragraphs = text.split("\n\n")
  paragraphs.each_with_index do |p,n|
    para = p.gsub(/\s+/,' ')
    puts "#{n+1}\t#{title}\t#{author}\t#{para}" unless para.empty?
  end
end

puts "n\ttitle\tauthor\tp" # headerline

to_tsv("the-idiot.txt", "The Idiot", "Dostoyevsky, Fyodor", 47, 368)
to_tsv("the-man-who-knew-too-much.txt", "The Man Who Knew Too Much", "Chesterton, Gilbert K", 51, 368)
to_tsv("war-and-peace.txt", "War and Peace", "Tolstoy, Leo", 806, 358)
to_tsv("the-sign-of-the-four.txt", "The Sign of the Four", " Doyle, Arthur C", 50, 370)

__END__
Example:

  head -47  the-idiot.txt
  tail -368 the-idiot.txt | head -20

the-idiot.txt
Title: Title: The Idiot
Author: Fyodor Dostoyevsky

the-man-who-knew-too-much.txt
Title: The Man Who Knew Too Much
Author: G.K. Chesterton

war-and-peace.txt
Title: War and Peace
Author: Leo Tolstoy

the-sign-of-the-four.txt
Title: The Sign of the Four
Author: Arthur Conan Doyle
