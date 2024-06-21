module Fastlane
  module Actions

    class ReleaseToGoogleDriveAction < Action
      def self.run(params)
        drive_keyfile = params[:drive_keyfile]
        root_folder_id = params[:root_folder_id]
        app_folder_id = find_or_create_folder(root_folder_id, params[:app_name], drive_keyfile)
        version_folder_id = find_or_create_folder(app_folder_id, params[:version_name], drive_keyfile)
        build_folder_id = find_or_create_folder(version_folder_id, "#{params[:build_number]}", drive_keyfile)

        Actions::UploadToGoogleDriveAction.run(
          drive_keyfile: drive_keyfile,
          service_account: false,
          folder_id: build_folder_id,
          upload_files: params[:upload_files]
        )
      end

      def self.find_or_create_folder(parend_id, folder_name, drive_keyfile)
        Actions::FindGoogleDriveFileByTitleAction.run(
          drive_keyfile: drive_keyfile,
          parent_folder_id: parend_id,
          file_title: folder_name,
          service_account: false,
        )

        subfolder_id = ""
        if lane_context[SharedValues::GDRIVE_FILE_ID]
          subfolder_id = lane_context[SharedValues::GDRIVE_FILE_ID]
        else
          sleep(4)
          Actions::CreateGoogleDriveFolderAction.run(
            drive_keyfile: drive_keyfile,
            service_account: false,
            parent_folder_id: parend_id,
            folder_title: folder_name
          )
          sleep(4)
          subfolder_id = lane_context[SharedValues::GDRIVE_FILE_ID]
        end
        subfolder_id
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Uploads builds to Google Drive release, with propper folder structure'
      end

      def self.details
        'Uploads builds to Google Drive release, with propper folder structure'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :drive_keyfile,
            env_name: 'FL_RELEASE_TO_GOOGLE_DRIVE_KEYFILE',
            description: 'Google Drive Keyfile file path',
            optional: false,
          ),
          FastlaneCore::ConfigItem.new(
            key: :upload_files,
            env_name: 'FL_RELEASE_TO_GOOGLE_DRIVE_UPLOAD_FILES',
            description: 'Files to upload',
            optional: false,
            type: Array,
          ),
          FastlaneCore::ConfigItem.new(
            key: :root_folder_id,
            env_name: 'FL_RELEASE_TO_GOOGLE_DRIVE_ROOT_FOLDER',
            description: 'Root folder to start release folder structure',
            optional: false,
          ),
          FastlaneCore::ConfigItem.new(
            key: :app_name,
            env_name: 'FL_RELEASE_TO_GOOGLE_DRIVE_APP_NAME',
            description: 'Application name. You should use different names for different flavors',
            optional: false,
          ),
          FastlaneCore::ConfigItem.new(
            key: :version_name,
            env_name: 'FL_RELEASE_TO_GOOGLE_DRIVE_VERSION_NAME',
            description: 'Version name',
            optional: false,
          ),
          FastlaneCore::ConfigItem.new(
            key: :build_number,
            env_name: 'FL_RELEASE_TO_GOOGLE_DRIVE_BUILD_NUMBER',
            description: 'Build number',
            type: Integer,
            optional: false,
          ),
        ]
      end

      def self.output
      end

      def self.return_value
      end

      def self.authors
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
