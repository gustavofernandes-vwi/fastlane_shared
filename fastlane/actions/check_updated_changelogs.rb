module Fastlane
    module Actions
      module SharedValues
        # CHECK_UPDATED_CHANGELOGS_CUSTOM_VALUE = :CHECK_UPDATED_CHANGELOGS_CUSTOM_VALUE
      end
  
      class CheckUpdatedChangelogsAction < Action
        def self.run(params)
          files = params[:files]
          time_limit = params[:limit]
  
          for file in files do
            modified = File.mtime(file)
            limit = modified + time_limit*60
  
            UI.message modified.utc
            UI.message limit.utc
            UI.message Time.now.utc
            if (limit.utc < Time.now.utc) then
              response = UI.select("Changelog is outdated. Do you wish to continue?: ", ["Yes", "No"])
              if response == 'No' then
                UI.abort_with_message! "Changelog is outdated"
              end
            end
          end
          nil
        end
  
        #####################################################
        # @!group Documentation
        #####################################################
  
        def self.description
          "Checks if changelogs are updated"
        end
  
        def self.details
          # Optional:
          # this is your chance to provide a more detailed description of this action
          "Checks if changelogs are updated and otherwise asks if user wants to update them"
        end
  
        def self.available_options
          [
            FastlaneCore::ConfigItem.new(
              key: :files,
              env_name: "FL_CHECK_UPDATED_CHANGELOGS_FILES",
              description: "Files for the changelogs",
              type: Array,
              optional: false,
            ),
            FastlaneCore::ConfigItem.new(
              key: :limit,
              env_name: "FL_CHECK_UPDATED_CHANGELOGS_TIME_LIMIT",
              description: "Time limit to consider a changelog outdated (in minutes)",
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
            # ['CHECK_UPDATED_CHANGELOGS_CUSTOM_VALUE', 'A description of what this value contains']
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
          true
        end
      end
    end
  end
  