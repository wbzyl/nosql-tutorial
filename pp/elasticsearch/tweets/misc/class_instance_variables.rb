
class Tweet

  class << self
    attr_accessor :client
    # def client=(c)
    #   @client = c
    # end

    # def client
    #   puts "client: #{@client}"
    # end
  end

end

Tweet.client = "wlodek"

put Tweet.client
