module Fastlane
  module Actions
    class RambnrollUploadAction < Action
      def self.run(params)
        puts "params.all_keys" + "#{params.all_keys}"
        puts "available_options" + "#{params.available_options}"
        project_name = params[:app_name]
        folder = params[:branch]
        ipa_path = params[:ipa_path]
        rambnroll_url = 'https://appdistribution.rambler.ru'
        
        conn = Faraday.new(:url => rambnroll_url) do |faraday|
          faraday.request :multipart
          faraday.request :url_encoded
          faraday.adapter :net_http
        end

        payload = { :project => project_name, 
                    :folder => folder,   
                    :build => Faraday::UploadIO.new(ipa_path, 'application/zip') }

        UI.message "Rolling to Rambnroll hosted at #{rambnroll_url} 🤘"
        conn.post('/builds/webhook_upload', payload)
        UI.message "Successfully uploaded to Rambnroll 🎉"
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