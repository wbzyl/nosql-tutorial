# -*- coding: utf-8  -*-

# verbose: print to stdderr / użyć Ruby Logger
# cat xxx | mongoimport  <-- ze stdin a nie ze stderr

require 'mail'
require 'iconv'
require 'faker'
require 'time'

require 'mongo'

coll = Mongo::Connection.new("localhost", 27017).db("mapreduce").collection("spam")

# http://www.ruby-doc.org/ruby-1.9/classes/Logger.html
require 'logger'

logger = Logger.new(STDERR)
logger.level = Logger::FATAL  # set the default level
#logger.level = Logger::INFO  # set the default level

username_from = Faker::Internet.user_name
username_to = Faker::Internet.user_name

marcin = /marcin\.babnis|marian\.babnis|(marcin|marian)@(math|inf|manta|speedway)/i

x_spam_report = "\\*\s+(-?[0-9]+(\.[0-9]+)?)\s+"

doc = {}

$/ = "\n\nFrom "
ic = Iconv.new 'UTF-8//IGNORE', 'UTF-8'

total_emails = 0

File.foreach('Filtered') do |box|
  total_emails += 1

  mail = Mail.read_from_string(ic.iconv('From ' + box))

  date = ic.conv(mail.header['Date'].to_s)

  subject = ic.conv(mail.header['Subject'].to_s).gsub(marcin, "root")
  subject.gsub!(/marian/, "root")

  spam_flag = ic.iconv(mail.header['X-Spam-Flag'].to_s)
  spam_level = ic.iconv(mail.header['X-Spam-Level'].to_s)
  spam_status = ic.conv(mail.header['X-Spam-Status'].to_s)
  spam_report = ic.conv(mail.header['X-Spam-Report'].to_s)

  from = mail.header['From'].to_s
  from.gsub!(marcin, username_from)

  if date.empty? || subject.empty? || spam_flag.empty? || spam_level.empty? || spam_status.empty? #|| spam_report.empty? || from.empty?
    # do nothing
  else
    t = Time.parse(date)
    doc['Date'] = Time.utc t.year, t.month, t.day, t.hour, t.min, t.sec
    doc['Subject'] = subject

    doc['X-Spam-Flag'] = spam_flag
    doc['X-Spam-Level'] = spam_level
    doc['X-Spam-Status'] = spam_status.match(/(.+) tests=/)[1]
    spam_tests = spam_status.match(/tests=(.+) autolearn/)[1].split(/,\s*/)

    doc['X-Spam-Tests'] = spam_tests
    logger.warn "No spam tests" if spam_tests.empty?

    #logger.info "Email \##{total_emails}"
    puts "\##{total_emails}"

    logger.warn spam_report

    doc['X-Spam-Report'] = {}
    spam_tests.each do |test|
      report = spam_report.match(x_spam_report + test)
      logger.warn "TEST: #{test}"
      doc['X-Spam-Report'][test] = report[1]
    end

    if data = /([^<]+)\s+<([^>]+)>/.match(from)
      doc['From-Text'] = data[1]
      doc['From'] = data[2]
    else
      doc['From'] = from
    end

  end

  coll.insert doc

  doc = {}

end

logger.info "Total emails: #{total_emails}"
