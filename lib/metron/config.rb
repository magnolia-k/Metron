class Config
  attr_reader :organization, :dependent_libraries, :testing_libraries, :sbt_plugins

  def initialize
    @organization = nil

    # default dependent library
    @dependent_libraries = []

    # default testing library
    @testing_libraries = [
      {
        :groupID          => "org.specs2",
        :artifactID       => "specs2-core",
        :is_scala_library => true,
        :version_style    => /^\d+\.\d+\.\d+$/
      }
    ]

    # default sbt plugin
    @sbt_plugins = [
      {
        :groupID => "org.scoverage",
        :artifactID => "sbt-scoverage",
        :version_style => /^\d+\.\d+\.\d+$/
      },
    ]
  end

  def set_config( config )
    # TODO: configuration's validation

    keywords = {
      :organization => @organization,

      :dependent_libraries => @dependent_libraries,
      :testing_libraries => @testing_libraries,
      :sbt_plugins => @sbt_plugins
    }
  
    keywords.keys.each do |keyword|
      keywords[keyword] = config[keyword] if config.has_key? keyword
    end
  end
end
