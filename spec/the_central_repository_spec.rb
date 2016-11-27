require "spec_helper"
require "metron/the_central_repository"

describe TheCentralRepositoryAPI do
  context "Invalid parameter" do
    example "Invalid param pattern" do
      expect {
        TheCentralRepositoryAPI.collect_artifact_versions("dummy", "dummy")
      }.to raise_error(RuntimeError)
    end
  end

  context "Collect artifact's version" do
    example "Access the API only once" do
      result = TheCentralRepositoryAPI.collect_artifact_versions("org.specs2", "specs2_2.8.1")
      expect(result.length).to be > 0
    end
    example "Access the API more than once" do
      result = TheCentralRepositoryAPI.collect_artifact_versions("junit", "junit")
      expect(result.length).to be > 0
    end
  end
end

