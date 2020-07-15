require 'json'
require 'date'
require 'dotenv/load'
require 'fileutils'
require 'csv'
require 'logger'

require './my_sql'
require './box_api'
require './file_backup'
require './uploader'

require 'pry'
require 'ostruct'

config = OpenStruct.new(
  year: ARGV[0],
  month: ARGV[1],
  day: ARGV[2],
  box_user_id: ENV['BOX_USER_ID'],
  box_folder_id: ENV['BOX_FOLDER_ID'],
  local_path: ENV['LOCAL_PATH']
)

search_timestamp = Time.new(config.year, config.month, config.day).utc
db_client = MySQL.new(search_timestamp)
emails = db_client.get_emails_from_db
return 'No new emails found' if emails.entries.empty?

file = BackupFile.new({ rows: emails.entries, directory: config.local_path })
file.save

# uploader = Uploader.new(BoxApi.new(config.box_user_id),
#                         file.full_path,
#                         config.box_folder_id)
#
# uploader.upload
#
# file.delete
