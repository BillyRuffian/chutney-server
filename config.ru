require 'bundler/setup'
Bundler.require

class App < Roda
  route do |r|
    r.root do
      'Hello, tasty chutney!'
    end

    r.on 'lint' do
      r.post do
        begin
          data = JSON.parse(r.body.read, symbolize_names: true)
          gherkin = data[:gherkin]
          temp_file = Tempfile.new('gherkin')
          temp_file.write(gherkin)
          temp_file.close
          linter = Chutney::ChutneyLint.new(temp_file.path)
          report = linter.analyse
          report[temp_file.path].reject { |linter| linter[:issues].empty? }.to_json
        rescue JSON::ParserError
          response.status = 400
          { error: 'Invalid JSON' }.to_json
        rescue StandardError => e
          response.status = 500
          { error: 'Badly formatted gherkin' }.to_json
        ensure
          temp_file.delete
        end
      end
    end
  end
end

run App.freeze.app
