require 'open-uri'
require 'rubygems/version'

class Sbt
  @@url = 'https://dl.bintray.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/'

  def initialize
    vers = open( @@url ) do |response|
      response.read.scan(/href=":\d+\.\d+\.\d+\/"/).map do |v|
        m = v.match(/(\d+\.\d+\.\d+)/)
        Gem::Version.new(m[1])
      end
    end

    @latest = vers.sort.last.to_s
  end

  def latest_version
    @latest
  end
end
