require "spec_helper"
require "metron/sbt"

describe Sbt do
  context "Fetch sbt's version info" do
    example "Fetch latest version" do
      sbt = Sbt.new
      expect(sbt).to_not be nil
    end
  end
end
