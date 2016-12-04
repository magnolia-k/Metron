require "spec_helper"
require "metron/artifact"

describe Artifact do
  context "Collect artifact's version number" do
    example "scala library - suffix scala major version" do
      artifact = Artifact.new(
        "org.specs2",
        "specs2-core",
        is_scala_library: true,
        version_style: '^\d+\.\d+\.\d+$'
      )
      expect(artifact.collect_versions("2.12.0").length).to be > 0
    end

    example "java library - no version suffix" do
      artifact = Artifact.new( "junit", "junit" )
      expect(artifact.collect_versions.length).to be > 0
    end
  end
end
