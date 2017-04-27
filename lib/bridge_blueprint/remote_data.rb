require 'open-uri'
require 'open_uri_redirections'
require 'net/http'
require 'uri'
require 'base64'
require "bridge_api"

module BridgeBlueprint

  class RemoteData

    USERS_CSV_NAME = 'users.csv'
    CUSTOM_FIELD_CSV_NAME = 'custom_fields.csv'
    GRANTS_CSV_NAME = 'grants.csv'

    @base_url = nil
    @auth_header = nil
    @file_url = nil
    @file_path = nil
    @is_complete = false
    @client = nil

    def initialize(base_url, key, secret)
      @base_url = base_url
      @auth_header = 'Basic ' +  Base64.strict_encode64("#{key}:#{secret}")
      @client = BridgeAPI::Client.new(prefix: base_url, api_key: key, api_secret: secret)
    end

    def start_data_report
       @client.create_data_dump
    end

    def status
      dumps = get_dumps
      if dumps.members.size > 0
        return get_dumps.first['status']
      else
        return BridgeBlueprint::Constants::STATUS_NOT_FOUND
      end
    end

    def store_file(path)
      @file_path = path
      uri = URI.parse(@base_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = 300
      http.use_ssl = (uri.scheme == "https")
      req = Net::HTTP::Get.new("#{@base_url}/api/admin/data_dumps/download")
      req.add_field("Authorization", @auth_header)
      res = http.request(req)
      redirect_url = res['location']
      open(redirect_url,
           ) do |remote_file|
        File.open(@file_path, 'wb') do |file|
          file.write(remote_file.read)
        end
      end
    end

    private

    def get_dumps
      @client.get_data_dumps
    end

    def get_headers
      {
          'Authorization'=> @auth_header,
          'Content-Type'=> 'application/json',
          'Accept'=> 'application/json'
      }
    end
  end

end
