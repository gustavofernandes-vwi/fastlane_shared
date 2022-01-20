module Fastlane
    module Actions
      module SharedValues
        # CHANGELOG_CUSTOM_VALUE = :CHANGELOG_CUSTOM_VALUE
      end
  
      class ChangelogAction < Action
        def self.run(params)
          create_files params if (!params[:skip_create_files])
          ensure_android_limit params if (!params[:skip_character_limit_check])
          check_outdated_changelogs params if (!params[:skip_outdated_changelogs_check])
          nil
        end

        def self.create_files(params)
          FileUtils.touch params[:ios_changelog_file] if (!params[:skip_ios] && !File.exists?(params[:ios_changelog_file]))
          FileUtils.touch params[:android_changelog_file] if (!params[:skip_android] && !File.exists?(params[:android_changelog_file]))
          FileUtils.touch params[:github_changelog_file] if (!params[:skip_github] && !File.exists?(params[:github_changelog_file]))
          UI.message "Created changelog files (if not already created)"
        end

        def self.ensure_android_limit(params)
          limit = params[:character_limit]
          callback = lambda do |changelog|
            if File.read(changelog).length > limit then
              UI.abort_with_message!("Android changelog '#{changelog}' is too long. Limit is #{limit} characters")
            end
          end
          walk_android_changelogs(params, callback)
          UI.message "There are no android changelogs longer than #{limit} characters"
        end

        def self.check_outdated_changelogs(params)
          time_limit = params[:outdated_limit]
          files = []

          files << params[:ios_changelog_file] unless params[:skip_ios]
          files << params[:android_changelog_file] unless params[:skip_android]
          files << params[:github_changelog_file] unless params[:skip_github]
          walk_android_changelogs(
            params,
            lambda do |changelog|
              files << params[:android_changelog_file]
            end
          )
  
          for file in files do
            modified = File.mtime(file)
            limit = modified + time_limit*60
  
            if (limit.utc < Time.now.utc) then
              response = UI.select("Changelog '#{file}' is outdated. Do you wish to continue?: ", ["Yes", "No"])
              if response == 'No' then
                UI.abort_with_message! "Changelog '#{file}' is outdated"
              end
            end
          end
          UI.message "All changelogs are updated"
        end

        def self.walk_android_changelogs(params,callback)
          android_metadata_folder = params[:android_metadata_folder]
          version = params[:app_version]
  
          for dir in Dir.entries(android_metadata_folder) do
            if !['.','..'].include?(dir) then
              changelog = ""
              if version && File.exist?("#{android_metadata_folder}/#{dir}/changelogs/#{version}.txt") then
                changelog = "#{android_metadata_folder}/#{dir}/changelogs/#{version}.txt"
              elsif File.exist?("#{android_metadata_folder}/#{dir}/changelogs/default.txt") then
                changelog = "#{android_metadata_folder}/#{dir}/changelogs/default.txt"
              end
              callback.call(changelog)
            end
          end
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
          [
            FastlaneCore::ConfigItem.new(
              key: :skip_ios,
              env_name: "CHANGELOG_SKIP_IOS",
              description: "Skip iOS changelogs",
              is_string: false,
              default_value: false,
            ),
            FastlaneCore::ConfigItem.new(
              key: :skip_android,
              env_name: "CHANGELOG_SKIP_ANDROID",
              description: "Skip Android changelogs",
              is_string: false,
              default_value: false,
            ),
            FastlaneCore::ConfigItem.new(
              key: :skip_github,
              env_name: "CHANGELOG_SKIP_GITHUB",
              description: "Skip Github changelogs",
              is_string: false,
              default_value: false,
            ),
            FastlaneCore::ConfigItem.new(
              key: :skip_character_limit_check,
              env_name: "CHANGELOG_SKIP_CHARACTER_LIMIT_CHECK",
              description: "Skip check for character limit",
              is_string: false,
              default_value: false,
            ),
            FastlaneCore::ConfigItem.new(
              key: :skip_create_files,
              env_name: "CHANGELOG_SKIP_CREATE_FILES",
              description: "Skip create new files",
              is_string: false,
              default_value: false,
            ),
            FastlaneCore::ConfigItem.new(
              key: :skip_outdated_changelogs_check,
              env_name: "CHANGELOG_SKIP_OUTDATED_CHECKLOGS_CHECK",
              description: "Skip check for outdated changelogs",
              is_string: false,
              default_value: false,
            ),
            FastlaneCore::ConfigItem.new(
              key: :android_metadata_folder,
              env_name: "CHANGELOG_ANDROID_METADATA_FOLDER",
              description: "Android metadata folder",
              optional: true,
              default_value: './fastlane/metadata/android',
            ),
            FastlaneCore::ConfigItem.new(
              key: :android_changelog_file,
              env_name: "CHANGELOG_ANDROID_FILE",
              description: "Android changelog file",
              optional: true,
              default_value: './fastlane/metadata/android/pt-BR/changelogs/default.txt',
            ),
            FastlaneCore::ConfigItem.new(
              key: :ios_changelog_file,
              env_name: "CHANGELOG_IOS_FILE",
              description: "iOS changelog file",
              optional: true,
              default_value: './fastlane/metadata/ios/changelog.md',
            ),
            FastlaneCore::ConfigItem.new(
              key: :github_changelog_file,
              env_name: "CHANGELOG_GITHUB_FILE",
              description: "github changelog file",
              optional: true,
              default_value: './fastlane/metadata/github/changelog.md',
            ),
            FastlaneCore::ConfigItem.new(
              key: :app_version,
              env_name: "CHANGELOG_APP_VERSION",
              description: "App version to look for android changelog (if not informed, will only look for default changelogs)",
              optional: true,
            ),
            FastlaneCore::ConfigItem.new(
              key: :character_limit,
              env_name: "CHANGELOG_CHARACTER_LIMIT",
              description: "Character limit",
              optional: true,
              type: Fixnum,
              default_value: 500,
            ),
            FastlaneCore::ConfigItem.new(
              key: :outdated_limit,
              env_name: "CHANGELOG_OUTDATED_LIMIT",
              description: "Time limit to consider that a changelog is outdated (in minutes)",
              type: Fixnum,
              optional: true,
              default_value: 30,
            ),
          ]
        end
  
        def self.output
          # Define the shared values you are going to provide
          # Example
          [
            # ['CHANGELOG_CUSTOM_VALUE', 'A description of what this value contains']
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
          [:android,:ios,:github].include?(platform)
        end
      end
    end
  end
  