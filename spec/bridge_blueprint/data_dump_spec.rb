require "test_helper"
require 'zip'

describe BridgeBlueprint::DataDump do

  before(:each) do
    dir = Dir.mktmpdir
    zip_folder_path = "#{File.dirname(__FILE__)}/../fixtures/bridge_zip"
    input_filenames = [
        'users.csv',
        'custom_fields.csv'
      ]

    @zipfile_name = "#{dir}/dump.zip"

    Zip::File.open(@zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        zipfile.add(filename, zip_folder_path + '/' + filename)
      end
    end
  end

  describe 'each' do
    it 'should parse a bridge data dump file' do
      file = BridgeBlueprint::DataDump.new(@zipfile_name)
      user_count = 0
      file.each_row('users') do |user|
        user_count += 1
      end
      custom_field_count = 0
      file.each_row('custom_fields') do |custom_field|
        custom_field_count += 1
      end
      expect(user_count).to(eq(8))
      expect(custom_field_count).to(eq(5))
    end
  end
end
