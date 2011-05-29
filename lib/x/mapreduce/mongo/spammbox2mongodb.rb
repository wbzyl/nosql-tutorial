# -*- coding: utf-8  -*-

require 'mail'
require 'iconv'
require 'faker'
require 'yajl'

username_from =  Faker::Internet.user_name
username_to = Faker::Internet.user_name

marcin = /marcin\.babnis|marian\.babnis|(marcin|marian)@(math|inf|manta|speedway)/i

hash = {}

$/ = "\n\nFrom "
ic = Iconv.new 'UTF-8//IGNORE', 'UTF-8'

total_emails = 0

File.foreach('Filtered') do |box|
  total_emails += 1

  begin
    mail = Mail.read_from_string(ic.iconv('From ' + box))

    date = mail.header['Date'].to_s
    # puts "Date: #{date}"
    hash['Date'] = mail.header['Date'].to_s if !date.empty?

    subject = mail.header['Subject'].to_s.gsub(marcin, "root")
    subject.gsub!(/marian/, "root")
    # puts "Subject: #{subject}"
    hash['Subject'] = mail.header['Subject'].to_s if !subject.empty?

    # puts mail.header['X-Spam-Flag'].to_s      # zawsze YES
    ### puts mail.header['X-Spam-Level'].to_s
    ### puts mail.header['X-Spam-Status'].to_s
    ### puts mail.header['X-Spam-Report'].to_s

    hash['X-Spam-Level'] = mail.header['X-Spam-Level'].to_s
    # hash['X-Spam-Status'] = mail.header['X-Spam-Status'].to_s

    spam_status = mail.header['X-Spam-Status'].to_s

    if spam_status.empty?
      # do nothing
    else
      hash['X-Spam-Status'] = spam_status
      hash['X-Spam-Tests'] = spam_status.match(/tests=(.+) autolearn/)[1].split(/,\s*/)
    end

    hash['X-Spam-Report'] = mail.header['X-Spam-Report'].to_s

    from = mail.header['From'].to_s
    from.gsub!(marcin, username_from)
    #puts "From: #{from}"

    if data = /([^<]+)\s+<([^>]+)>/.match(from)
      # puts "From text: #{data[1]}"
      # puts "From: #{data[2]}"  # może być kilka emaili oddzielonych przecinkam
      hash['From'] = data[2]
    else
      # puts "From: #{from}"
      hash['From'] = from
    end

    # to = mail.header['To'].to_s
    # to.gsub!(marcin, username_to)
    # #puts "To: #{to}"

    # if data = /([^<]+)\s+<([^>]+)>/.match(to)
    #   puts "To text: #{data[1]}"
    #   puts "To: #{data[2]}" # może być kilka emaili oddzielonych przecinkami
    # else
    #   puts "To: #{to}"
    # end

    puts  Yajl::Encoder.encode(hash)

  rescue
   # ignore all errors
  end

  # print "-- #{total_emails} --------------\n"

  box = ""
  date = ""
  subject = ""
  from = ""
  to = ""
  spam_status = ""
  hash = {}

  # puts mail.header['X-Original-To'].to_s
end

puts "Total emails: #{total_emails}"
