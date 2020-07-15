require 'mysql2'
require 'pry'

class MySQL
  attr_accessor :timestamp

  def initialize(timestamp, client = nil)
    @timestamp = timestamp
    if not client.nil?
      @client = client

    elsif ENV.fetch("TENANCY") == "local"
      @client = Mysql2::Client.new(
          :host => ENV.fetch("LOCAL_DB_HOSTNAME"), 
          :username => ENV.fetch("LOCAL_DB_USERNAME"),
          :password => ENV.fetch("LOCAL_DB_PW"),
          :database => ENV.fetch("LOCAL_DB_NAME"),
          :reconnect => true
      )
    else
      @client = Mysql2::Client.new(
          :host => ENV.fetch("DB_HOSTNAME"), 
          :username => ENV.fetch("DB_USERNAME"),
          :password => ENV.fetch("DB_PW"),
          :database => ENV.fetch("DB_NAME"),
          :reconnect => true
      )
    end
  end

  def get_emails_from_db
    date_range_query = "SELECT address, date FROM messages WHERE DATE(date) " \
                        "BETWEEN '#{modify_date(@timestamp)}'" \
                          "AND '#{modify_date(Time.now.utc)}'" \
                            "AND msg_type = 'email'"

    @client.query(date_range_query)
  end

  private

  def modify_date(date)
    date.strftime("%Y-%m-%d")
  end
end


