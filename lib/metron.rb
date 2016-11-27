require 'tmpdir'
require 'open-uri'
require 'metron/artifact'
require 'metron/scala'
require 'metron/sbt'

class MetronApp
  def initialize( name, dependent_libraries: [], testing_libraries: [], sbt_plugins: [] )
    @name = name
    @dependent_libraries = dependent_libraries
    @testing_libraries = testing_libraries
    @sbt_plugins = sbt_plugins

    @scala = Scala.new
    @sbt   = Sbt.new

    @version = "0.0.1-SNAPSHOT"
  end

  def create_library( dir )
    Dir.mktmpdir do |tmpdir|
      create_directories( tmpdir )

      create_build_sbt( tmpdir )
      create_build_properties( tmpdir )

      create_sbt_shellscript( tmpdir )
      download_sbt_launch( tmpdir )
    
      create_plugin_sbt( tmpdir )

		  path = Pathname.new( File.join(tmpdir, @name ) )
      FileUtils.cp_r( path, dir)
    end
  end

  private

  def create_directories( path )
		dirs = [ 'main', 'test' ]
		subdirs = [ 'scala', 'java', 'resources' ]

		home = Pathname.new( File.join(path, @name ) )

		for d in dirs do
			for s in subdirs do
				FileUtils.mkdir_p( home.join('src', d, s) )
			end
		end

		otherdirs = [ 'target', 'lib', 'project' ]

		for o in otherdirs do
			FileUtils.mkdir_p( home.join(o) )
		end
  end

  def create_build_sbt( path )
    libs = []
      
    @dependent_libraries.each do |a|
      artifact = Artifact.new(
        a[:groupID],
        a[:artifactID],
        is_scala_library: a.key?(:is_scala_library) ? a[:is_scala_library] : nil,
        version_style: a.key?(:version_style) ? a[:version_style] : nil
      )
      version = artifact.latest_version( @scala.latest_version )

      libs.push( %!"#{a[:groupID]}" %% "#{a[:artifactID]}" % "#{version}"! )
    end

    @testing_libraries.each do |a|
      artifact = Artifact.new(
        a[:groupID],
        a[:artifactID],
        is_scala_library: a.key?(:is_scala_library) ? a[:is_scala_library] : nil,
        version_style: a.key?(:version_style) ? a[:version_style] : nil
      )
      version = artifact.latest_version( @scala.latest_version )

      libs.push( %!"#{a[:groupID]}" %% "#{a[:artifactID]}" % "#{version}" % "test"! )
    end

    buildsbt =<<~EOF
    name := "#{@name}"
    version := "#{@version}"
    scalaVersion := "#{@scala.latest_version}"

    libraryDependencies ++= Seq(
      #{libs.join(",\n  ")}
    )
    EOF

    # for specs2
    @testing_libraries.each do |l|
      if l[:artifactID] == "specs2-core" then
        buildsbt += "\n"
        buildsbt += %{scalacOptions in Test ++= Seq("-Yrangepos")\n}
      end
    end

    buildsbt_file = Pathname.new( File.join(path, @name, "build.sbt" ) )
    open( buildsbt_file, "w" ) do |output|
      output.write( buildsbt )
    end
    
  end

  def create_build_properties( path )
    build_properties_file = Pathname.new( File.join(path, @name, "project", "build.properties" ) )

    open( build_properties_file, "w" ) do |output|
      output.write("sbt.version=#{@sbt.latest_version}")
    end
  end

  def create_sbt_shellscript( path )
    shellscript_file = Pathname.new( File.join(path, @name, "sbt" ) )

    sbt =<<~EOF
    #!/bin/bash
    SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled"
    java $SBT_OPTS -jar `dirname $0`/sbt-launch.jar "$@"
    EOF

    open(shellscript_file, "w") do |output|
      output.write(sbt)
    end

    `chmod +x #{shellscript_file}`

  end

  def download_sbt_launch( path )
    sbt_launch_file = Pathname.new( File.join(path, @name, "sbt-launch.jar" ) )

    site = 'http://dl.bintray.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/'

    url = site + @sbt.latest_version + '/sbt-launch.jar'

    open( sbt_launch_file, 'wb') do |write_file|
      open(url, 'rb') do |read_file|
        write_file.write(read_file.read)
      end
    end
  end

  def create_plugin_sbt( path )
    libs = []
      
    @sbt_plugins.each do |a|
      artifact = Artifact.new(
        a[:groupID],
        a[:artifactID],
        is_scala_library: a.key?(:is_scala_library) ? a[:is_scala_library] : nil,
        version_style: a.key?(:version_style) ? a[:version_style] : nil
      )
      version = artifact.latest_version

      libs.push( %!addSbtPlugin("#{a[:groupID]}" % "#{a[:artifactID]}" % "#{version}")! )
    end

    plugin_sbt_file = Pathname.new( File.join(path, @name, "project", "plugin.sbt" ) )
    open(plugin_sbt_file, "w") do |output|
      output.write( libs.join("\n") )
    end
  end
end
