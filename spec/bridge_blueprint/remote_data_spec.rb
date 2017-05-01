require "test_helper"
require 'zip'

describe BridgeBlueprint::RemoteData do

  before(:each) do
    @dir = Dir.mktmpdir
    zip_folder_path = "#{File.dirname(__FILE__)}/../fixtures/bridge_zip"
    input_filenames = [
        'users.csv',
        'custom_fields.csv'
      ]

    @zipfile_name = "#{@dir}/dump.zip"

    Zip::File.open(@zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        zipfile.add(filename, zip_folder_path + '/' + filename)
      end
    end

    stub_request(:get, "https://example.com/fake-file-url").
       with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => lambda{|request| File.open(@zipfile_name)}, :headers => {})
  end

  describe 'completed' do
    it 'should start a data dump' do
      data = BridgeBlueprint::RemoteData.new('https://example.com', 'key', 'secret')
      data.start_data_report
    end
  end

  describe 'completed' do
    it 'should check if a data dump is complete' do
      data = BridgeBlueprint::RemoteData.new('https://example.com', 'key', 'secret')
      expect(data.status == BridgeBlueprint::Constants::STATUS_COMPLETE).to(eq(true))
    end
  end

  describe 'store_file' do
    it 'should store a data dump file locally' do
      data = BridgeBlueprint::RemoteData.new('https://example.com', 'key', 'secret')
      dir = Dir.mktmpdir
      data.store_file("#{@dir}/data_dump.csv")
      expect(File.exists?("#{@dir}/data_dump.csv")).to(eq(true))
    end
  end

end
