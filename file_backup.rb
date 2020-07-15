class BackupFile
  def initialize(rows:, date: DateTime.now.strftime("%m-%d-%Y").to_s, directory: "./tmp")
    @rows = rows
    @date = date
    @directory = directory
  end

  def save
    CSV.open(full_path, "wb") do |csv|
      rows.each do |entry|
        csv << [entry.values[0], entry.values[1]]
      end
    end
  end

  def full_path
    File.join(@directory, filename)
  end

  def delete
    FileUtils.rm(full_path)
  end

  private

  attr_reader :rows, :date

  def filename
    "access-emails-#{date}"
  end
end
