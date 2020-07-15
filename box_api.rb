require 'boxr'

class BoxApi
  attr_reader :user_id, :private_key, :private_key_password, :public_key_id,
              :client_id, :client_secret, :box_folder_id, :box_domain

  def initialize(user_id)
    @user_id              = user_id
    @private_key          = ENV.fetch('JWT_PRIVATE_KEY')
    @private_key_password = ENV.fetch('JWT_PRIVATE_KEY_PASSWORD')
    @public_key_id        = ENV.fetch('JWT_PUBLIC_KEY_ID')
    @client_id            = ENV.fetch('BOX_CLIENT_ID')
    @client_secret        = ENV.fetch('BOX_CLIENT_SECRET')
  end

  def client
    @client ||= Boxr::Client.new(token.access_token)
  end

  def token
    Boxr.get_user_token(@user_id,
                        private_key: @private_key,
                        private_key_password: @private_key_password,
                        public_key_id: @public_key_id,
                        client_id: @client_id,
                        client_secret: @client_secret)
  end

  def get_files_from_folder(folder)
    folder_items = client.folder_items(folder)
    folder_items.select{|i| i.type.downcase == "file"}
  end

  def get_child_folders(folder)
    folder_items = client.folder_items(folder)
    folder_items.select{|i| i.type.downcase == "folder"}
  end

  def folder(box_folder_id)
    client.folder_from_id(box_folder_id)
  end

  def upload(file_path, file_name, box_folder_id)
    client.upload_file(file_path, self.folder(box_folder_id))
  rescue Boxr::BoxrError => err
    # If box erred b/c file already exists, we should replace file with new copy
    raise err unless err.status == 409 || err.code == "item_name_in_use"

    folder = folder(box_folder_id)
    file = get_files_from_folder(folder).find{|f| f.name == file_name}
    client.upload_new_version_of_file(file_path, file)
  end

  def retrieve_box_file_json(box_file_url)
    client.shared_item(box_file_url)
  end

  def download_box_file(file_id)
    client.file_from_id(file_id)
  end

  def download_file(file)
    client.download_file(file)
  end

  def create_folder(name, parent_id)
    parent = client.folder_from_id(parent_id)
    client.create_folder(name, parent)
  end

  # If there are two files with the same name, this function picks the first one it encounters
  def download_file_by_name(fname)
    file = find_file_by_name(fname).shift
    client.download_file(file)
  end

  def client_folder(client_folder_name)
    box_items = find_file_by_name(client_folder_name)
    box_items.find { |box_item| box_item['name'] == client_folder_name }
  end

  def find_file_by_name(file_name)
    # TODO: use a different api method so there is no delay.
    # Can we search by folder id?
    client.search(file_name)
  end

  def delete_file(file)
    client.delete_file(file)
  end

  def delete_folder(folder)
    client.delete_folder(folder, recursive: true)
  end
end
