class Uploader
  def initialize(client:, path:, remote_folder:)
    @client = client
    @path = path
    @remote_folder = remote_folder
  end

  def upload
    client.upload(path, file_name, remote_folder)
  end

  private

  attr_reader :client, :path, :remote_folder

  def file_name
    File.basename(path)
  end
end
