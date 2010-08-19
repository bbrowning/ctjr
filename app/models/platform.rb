class Platform < ActiveRecord::Base
  has_many :platform_versions

  accepts_nested_attributes_for :platform_versions

  def to_s
    name
  end

  # Create new Platform(s) from the given YAML file
  #
  # This is only meant to be used for creating new platforms, not for
  # updating existing ones. An example of the expected YAML file syntax:
  #
  # ---
  # platforms:
  #   - name: Test Platform
  #     platform_versions:
  #       - version_number: 123
  #         images:
  #           - name: Test Image 123
  #             cloud_id: ami_123
  #             role: frontend
  #           - name: Test Image 234
  #             cloud_id: ami_234
  #             role: backend
  #       - version_number: 234
  #         images:
  #           - cloud_id: ami_123
  #
  # When specifying images for a PlatformVersion, the cloud_id is
  # required. If an Image already exists with the same cloud_id then
  # it will be used, otherwise a new Image will be created and any
  # extra Image attributes you pass will get used for the creation.
  #
  def self.create_from_yaml(file_path)
    yaml = YAML::load_file(file_path)
    yaml['platforms'].each do |platform_yaml|
      platform_versions = platform_yaml.delete('platform_versions')
      platform = Platform.new(platform_yaml)
      unless platform_versions.nil?
        platform_versions.each do |version_yaml|
          images = version_yaml.delete('images')
          version = PlatformVersion.new(version_yaml)
          unless images.nil?
            images.each do |image_yaml|
              version.images << Image.find_or_create_by_cloud_id(image_yaml)
            end
          end
          platform.platform_versions << version
        end
      end
      platform.save!
    end
  end
end
