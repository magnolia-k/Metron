require "spec_helper"
require "spec_helper"
require "metron/scala"

describe Scala do
  context "Fetch scala's version info" do
    example "Fetch latest version" do
      scala = Scala.new
      ver = scala.latest_version
      expect(ver).to_not be nil
    end

    example "Fetch latest version for each major version" do
      scala = Scala.new
      vers = scala.latest_version_for_each_major_version
      expect(vers.keys.length).to be > 0
    end
  end
end

require "metron/scala"

describe Scala do
  context "Fetch scala's version info" do
    example "Fetch latest version" do
      scala = Scala.new
      ver = scala.latest_version
      expect(ver).to_not be nil
    end

    example "Fetch latest version for each major version" do
      scala = Scala.new
      vers = scala.latest_version_for_each_major_version
      expect(vers.keys.length).to be > 0
    end
  end
end

