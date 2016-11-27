require 'open-uri'
require 'json'
require 'rubygems/version'

module TheCentralRepositoryAPI
  module_function

  def collect_artifact_versions(groupID, artifactID)
    url = %!http://search.maven.org/solrsearch/!
    param = %!select?q=g:"#{groupID}"+AND+a:"#{artifactID}"&core=gav&rows=20&wt=json!

    start = 0
    is_finished = false
    versions = []

    begin
      open( url + param + "&start=#{start}" ) do |response|
        result = JSON.parse(response.read)

        if result["response"]["numFound"] == 0 then
          raise "Can't find artifact -> groupID: #{groupID}, artifactID: #{artifactID}"
        end

        result["response"]["docs"].each do |doc|
          versions.push( Gem::Version.create(doc["v"]) )
        end

        if versions.length < result["response"]["numFound"] then
          start = versions.length
        else
          is_finished = true
        end
      end
    end while is_finished == false

    versions.sort.map do |ver| ver.to_s end
  end
end
