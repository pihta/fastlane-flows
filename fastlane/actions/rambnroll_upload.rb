module Fastlane
  module Actions
    class RambnrollUploadAction < Action
      def self.run(params)
        project_name = params[:app_name]
        folder = params[:branch]
        ipa_path = params[:ipa_path]

        conn = Faraday.new(:url => 'https://appdistribution.rambler.ru') do |faraday|
          faraday.request :multipart
          faraday.request :url_encoded
          faraday.adapter :net_http
        end

        payload = { :project => project_name, 
                    :folder => folder,   
                    :build => Faraday::UploadIO.new(ipa_path, 'application/zip') }

        conn.post('/builds/webhook_upload', payload)
      end

      def self.description
        'Upload build to Rambnroll'
      end

      def self.authors
        ["i.kvyatkovskiy"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end