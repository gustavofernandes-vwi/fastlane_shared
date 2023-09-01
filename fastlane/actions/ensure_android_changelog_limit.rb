module Fastlane
    module Actions
      module SharedValues
        # ENSURE_ANDROID_CHANGELOG_LIMIT_CUSTOM_VALUE = :ENSURE_ANDROID_CHANGELOG_LIMIT_CUSTOM_VALUE
      end
  
      class EnsureAndroidChangelogLimitAction < Action
        def self.run(params)
          android_metadata_folder = params[:android_metadata_folder]
          version = params[:version]
          limit = params[:limit]
  
          for dir in Dir.entries(android_metadata_folder) do
            if !['.','..'].include?(dir) then
              changelog = ""
              if version && File.exist?("#{android_metadata_folder}/#{dir}/changelogs/#{version}.txt") then
                changelog = File.read("#{android_metadata_folder}/#{dir}/changelogs/#{version}.txt")
              elsif File.exist?("#{android_metadata_folder}/#{dir}/changelogs/default.txt") then
                changelog = File.read("#{android_metadata_folder}/#{dir}/changelogs/default.txt")
              end
              if changelog.length > limit then
                UI.abort_with_message!("Android changelog for language #{dir} is too long. Limit is #{limit} characters")
              end
            end
          end
          UI.message "There are no android changelogs longer than #{limit} characters"
          nil
        end
  
        #####################################################
        # @!group Documentation
        #####################################################
  
        def self.description
          "Ensures Android changelogs to be within limits"
        end
  
        def self.details
          # Optional:
          # this is your chance to provide a more detailed description of this action
          "Stops lane excecution if there are any Android changelogs longer than Google Play limits"
        end
  
        def self.available_options
          # Define all options your action supports.
  
          # Below a few examples
          [
            FastlaneCore::ConfigItem.new(
              key: :android_metadata_folder,
              env_name: "FL_ENSURE_ANDROID_CHANGELOG_LIMIT_METADATA_FOLDER",
              description: "Android metadata folder",
              optional: true,
              default_value: './fastlane/metadata/android',
            ),
            FastlaneCore::ConfigItem.new(
              key: :version,
              env_name: "FL_ENSURE_ANDROID_CHANGELOG_LIMIT_VERSION",
              description: "App version to look for changelog (if not informed, will only look for default changelogs)",
              optional: true,
              default_value: './fastlane/metadata/android',
            ),
            FastlaneCore::ConfigItem.new(
              key: :limit,
              env_name: "FL_ENSURE_ANDROID_CHANGELOG_LIMIT_VALUE",
              description: "Character limit",
              optional: true,
              type: Integer,
              default_value: 500,
            ),
          ]
        end
  
        def self.output
          # Define the shared values you are going to provide
          # Example
          [
            # ['ENSURE_ANDROID_CHANGELOG_LIMIT_CUSTOM_VALUE', 'A description of what this value contains']
          ]
        end
  
        def self.return_value
          # If your method provides a return value, you can describe here what it does
        end
  
        def self.authors
          # So no one will ever forget your contribution to fastlane :) You are awesome btw!
          ["Gustavo Fernandes"]
        end
  
        def self.is_supported?(platform)
          [:android].include?(platform)
        end
      end
    end
  end
  