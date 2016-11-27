require 'metron/artifact'

class Scala
  def initialize
    scala_compiler = Artifact.new(
      "org.scala-lang",
      "scala-compiler",
      version_style: /^2\.\d+\.\d+$/
    )

    @vers = scala_compiler.collect_versions
  end

  def latest_version
    @vers.last
  end

  def latest_version_for_each_major_version
    scala_vers = {}
    @vers.reverse_each do |ver|
      m = /^(?<major>2\.\d+)\.\d+$/.match(ver)
      scala_vers[m[:major]] = ver unless scala_vers.key?(m[:major])
    end

    scala_vers
  end
end
