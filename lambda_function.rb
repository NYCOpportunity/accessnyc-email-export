require 'json'
require 'date'
require 'dotenv/load'
require 'fileutils'
require 'csv'
require 'logger'
require './my_sql'
require './box_api'
require 'pry'

begin
  year = ARGV[0]
  month = ARGV[1]
  day = ARGV[2]

  search_timestamp = Time.new(year, month, day).utc

  db_client = MySQL.new(search_timestamp)

  emails = db_client.get_emails_from_db
  return 'No new emails found' if emails.entries.empty?

  box = BoxApi.new(ENV['BOX_USER_ID'])

  date = DateTime.now.strftime("%m-%d-%Y").to_s
  file_name = "access-emails-#{date}"

  CSV.open("./tmp/#{file_name}.csv", "wb") do |csv|
    emails.entries.each do |entrie|
      csv << [entrie.values[0], entrie.values[1]]
    end
  end

  box.upload_file_to_box("./tmp/#{file_name}.csv", file_name, ENV['BOX_FOLDER_ID'])

  FileUtils.rm("./tmp/#{file_name}.csv")

  puts "successfully uploaded CSV file to Box"
rescue StandardError => e
  logger = Logger.new(STDOUT)
  logger.level = ENV.fetch('LOG_LEVEL', Logger::INFO)
  logger.datetime_format = '%Y-%m-%d %H:%M:%S '
  logger.error("msg: #{e}, trace: #{e.backtrace.join("\n")}")
end

