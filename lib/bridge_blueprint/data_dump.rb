require 'csv'

module BridgeBlueprint
  class DataDump

    @path = nil

    def initialize(path)
      @path = path
      unless File.exists?(path)
        raise "File not found #{path}"
      end
    end

    def each_row(name)
      extract_from_zip("#{name}.csv") do |file|
        CSV.foreach(file, headers: true) do |row|
          yield(row)
        end
      end
    end

    private

    def extract_from_zip(name)
      Dir.mktmpdir do |dir|
        path = nil
        Zip::File.open(@path) do |zip_file|
          zip_file.each do |entry|
            if "#{name.to_s}" == entry.name
              path = "#{dir}/#{entry.name}"
              file = entry.extract(path)
              yield "#{dir}/#{name}" if block_given?
              return
            end
          end
          raise "File #{name} not found in zip archive #{@path}"
        end
      end
    end
  end
end
