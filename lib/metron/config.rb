require 'yaml'

class Config
  attr_reader :organization, :dependent_libraries, :testing_libraries, :sbt_plugins

  def initialize
    @organization = nil

    # default dependent library
    @dependent_libraries = []

    # default testing library
    @testing_libraries = [
      {
        :groupID          => 'org.specs2',
        :artifactID       => 'specs2-core',
        :is_scala_library => true,
        :version_style    => '^\d+\.\d+\.\d+$'
      }
    ]

    # default sbt plugin
    @sbt_plugins = [
      {
        :groupID => 'org.scoverage',
        :artifactID => 'sbt-scoverage',
        :version_style => '^\d+\.\d+\.\d+$'
      },
    ]
  end

  def set_config( config_file )
    config = YAML.load_file( config_file )  

    # TODO: configuration's validation

    @organization = config["organization"] if config.has_key? "organization"
    @dependent_libraries = config["dependent_libraries"] if config.has_key? "dependent_libraries"
    @testing_libraries = config["testing_libraries"] if config.has_key? "testing_libraries"
    @sbt_plugins = config["sbt_plugins"] if config.has_key? "sbt_plugins"
  end
end
