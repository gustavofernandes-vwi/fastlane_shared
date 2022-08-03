require 'erb'

module Fastlane
  module Actions
    module SharedValues
      CHANGELOG_MAKER_CUSTOM_VALUE = :CHANGELOG_MAKER_CUSTOM_VALUE
    end

    class ChangelogMakerAction < Action
      def self.run(params)
        spec = YAML.load_file(params[:spec_path])
        
        version = {}

        if (spec['versions'].key?(params[:version])) then
          version = spec['versions'][params[:version]]
        else
          UI.abort_with_message! "Version #{params[:version]} not found in changelog spec"
        end

        if (version.empty?) then
          UI.abort_with_message! "No changelog found for version #{params[:version]} in changelog spec"
        end

        builds = {}
        if (version.kind_of?(Array)) then
          builds = version
        else
          builds = version['builds']
        end

        changes = []
        builds.each do |build, items|
          changes = changes + parse(items, build)
        end

        assemble(params, spec, changes)
      end

      def self.parse(item, build, tags = [])
        if (item.kind_of?(String)) then
          return [Change.new(item, build, tags)]
        end
        if (item.kind_of?(Array)) then
          changes = []
          item.each do |child|
            changes = changes + parse(child, build, tags)
          end
          return changes
        end
        if (item.kind_of?(Hash)) then
          changes = []
          item.each do |key, value|
            tag = "#{key}"
            changes = changes + parse(value, build, tags + [tag])
          end
          return changes
        end
      end

      def self.assemble(params, spec, changes)
        platforms = spec['platforms']
        version = spec['versions'][params[:version]]
        builds = version['builds'].keys
        platforms.each do |platform|
          template = ERB.new(File.read(params[:templates][platform]), trim_mode: "-")
          result = template.result_with_hash(
            changes: ChangesList.new(changes),
            version: params[:version],
            build: params[:build],
            builds: builds,
            extraData: params[:extra_data],
            platform: platform,
            platforms: platforms,
          )
          File.write(params[:results][platform], result, mode: "w")
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Uses single input to assemble multiple changelogs based on their configuration"
      end

      def self.details
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :spec_path,
            env_name: "CHANGELOG_MAKER_SPEC_PATH",
            description: "Path for the spec file",
            optional: true,
            default_value: './fastlane/changelog_spec.yaml',
            type: String,
          ),
          FastlaneCore::ConfigItem.new(
            key: :version,
            env_name: "CHANGELOG_MAKER_VERSION",
            description: "App version for getting changelogs",
            optional: false,
            type: String,
          ),
          FastlaneCore::ConfigItem.new(
            key: :build,
            env_name: "CHANGELOG_MAKER_BUILD",
            description: "App build number for getting changelogs",
            optional: false,
            type: Integer,
          ),
          FastlaneCore::ConfigItem.new(
            key: :templates,
            env_name: "CHANGELOG_MAKER_TEMPLATES",
            description: "Hash with templates file path for each platform",
            optional: true,
            type: Hash,
          ),
          FastlaneCore::ConfigItem.new(
            key: :results,
            env_name: "CHANGELOG_MAKER_RESULTS",
            description: "Hash with results file path for each platform",
            optional: true,
            type: Hash,
          ),
          FastlaneCore::ConfigItem.new(
            key: :extra_data,
            env_name: "CHANGELOG_MAKER_EXTRA_DATA",
            description: "Extra data to be used on templates",
            optional: true,
          ),
        ]
      end

      def self.output
        []
      end

      def self.return_value
      end

      def self.authors
        ["93luiz"]
      end

      def self.is_supported?(platform)
        true
      end
    end

    class Change
      String @desc = ''
      Integer @build = 0
      Array @tags = []

      attr_reader :desc
      attr_reader :build
      attr_reader :tags

      def initialize(line, build, tags = [])
        @build = build
        @tags = tags
        regex = /^(?<tags>\([A-Za-z,]+\)) ?/
        matches = line.match regex
        if (matches) then
          @tags = @tags + matches['tags'].gsub(/[\(\) ]/, '').split(',')
        end
        @desc = line.gsub(regex, '')
      end

      def hasTag(tag)
        return @tags.include? tag
      end
    end

    class ChangesList
      Array @list

      attr_reader :list

      def initialize(list)
        @list = list
      end

      def length
        return @list.length
      end

      def filterTag(tag)
        new_list = @list.select {|c| c.hasTag tag}
        return ChangesList.new new_list
      end

      def filterNotTag(tag)
        new_list = @list.select {|c| !c.hasTag tag}
        return ChangesList.new new_list
      end

      def filterBuild(build)
        new_list = @list.select {|c| c.build == build}
        return ChangesList.new new_list
      end

      def filterNotBuild(build)
        new_list = @list.select {|c| c.build != build}
        return ChangesList.new new_list
      end

      def filterPlatform(platform, allPlatforms)
        notPlataforms = allPlatforms.select {|p| p != platform}
        new_list = list.select {|c| !(c.tags & notPlataforms).any?}
        return ChangesList.new new_list
      end
    end
  end
end
