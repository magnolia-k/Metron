require 'metron/the_central_repository'

class Artifact
  include TheCentralRepositoryAPI

  def initialize(groupID, artifactID, is_scala_library: false, version_style: nil)
    @groupID = groupID
    @artifactID = artifactID
    @is_scala_library = is_scala_library
    if version_style == nil then
      @version_style = nil
    else
      @version_style = /#{version_style}/
    end
  end

  def groupID
    @groupID
  end

  def artifactID
    @artifactID
  end

  def is_scala_library?
    @is_scala_library
  end

  def latest_version(scala_version = nil)
    collect_versions( scala_version ).last
  end

  def collect_versions( scala_version = nil )
    if is_scala_library? and scala_version == nil then
      raise "Must set argument 'scala_version' for scala library"
    end

    artifactID = if is_scala_library? then
                   matched = /^(?<major>2\.\d+)\.\d+/.match(scala_version)
                   @artifactID + "_" + matched[:major]
                 else
                   @artifactID
                 end

    versions = collect_artifact_versions( @groupID, artifactID )
  
    if @version_style == nil then
      versions
    else
      versions.grep( @version_style )
    end
  end
end
