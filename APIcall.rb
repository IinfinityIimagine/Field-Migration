#!/usr/bin/ruby
require 'net/http'
require 'json'

def getFromAcademic(options)
    id='bd27fc9dbab549b2bedc916169f768ee'
=begin
    uriI = URI('https://api.projectoxford.ai/academic/v1.0/interpret')
    uriI.query = URI.encode_www_form({
        # Request parameters
        'query' => name,
        'complete' => '1',
        'count' => '1',
        'offset' => '0',
        'model' => 'latest'
    })
    requestI = Net::HTTP::Get.new(uriI.request_uri)
    requestI['Ocp-Apim-Subscription-Key'] = id
    responseI = Net::HTTP.start(uriI.host, uriI.port, :use_ssl => uriI.scheme == 'https') do |http|
        http.request(requestI)
    end
    input=JSON.parse(responseI.body)["interpretations"][0]["rules"][0]["output"]["value"]
=end
    if(options["stddev"]!=nil)
        stddev=options["stddev"]
    elsif(options["name"]==nil)
        stddev=5
    else
        stddev=50
        options["year"]-=50 unless(options["year"]==nil)
    end
    abc=""
    abc+="And(" if(options.size>1)
    if(options["name"]!=nil)
        abc+="Composite("
        abc+="And(" if(options["place"]!=nil)
        abc+="AA.AuN=\'"+options["name"]+"\'"
        if(options["place"]==nil)
            abc+=")"
        else
            abc+=",AA.AfN=\'"+options["place"]+"\')"
        end
    elsif(options["place"]!=nil)
        abc+="Composite(AA.AfN=\'"+options["place"]+"\')"
    end
    unless(options["field"]==nil)
        abc+="," if(options["name"]!=nil or options["place"]!=nil)
        #abc+="Composite(F.FN=\'"+options["field"]+"\')" 
        abc+="Composite("
        abc+="Or(" if(options["field"].size>1)
        options["field"].each { |fld|
            abc+="F.FN=\'"+fld+"\', "
        }
        abc=abc.chop
        abc=abc.chop
        abc+=")" if(options["field"].size>1)
        abc+=")" 
    end
    unless(options["year"]==nil)
        abc+="," if(options.size>1)
        abc+="Y=["+(options["year"]-stddev).to_s+","+(options["year"]+stddev).to_s+"]" 
    end
    abc+=")" if(options.size>1)
    puts abc
    STDIN.gets
    uriE = URI('https://api.projectoxford.ai/academic/v1.0/evaluate')
    uriE.query = URI.encode_www_form({
        # Request parameters
        'expr' => abc,
        'model' => 'latest',
        'count' => '10000',
        'offset' => '0',
        'attributes' => 'Id,Ti,Y,D,CC,ECC,AA.AuN,AA.AfN,AA.AfId,F.FN,F.FId'
    })
    #puts uriE
    requestE = Net::HTTP::Get.new(uriE.request_uri)
    requestE['Ocp-Apim-Subscription-Key'] = id
    responseE = Net::HTTP.start(uriE.host, uriE.port, :use_ssl => uriE.scheme == 'https') { |http|
        http.request(requestE)
    }
    File.open(options["file"], "w") { |save| save.write(responseE.body)} unless(options["file"]==nil)
    final=JSON.parse(responseE.body)
    final['entities']
end

=begin test
getFromAcademic( {

#"name"=>"sahil pandey",
#"place"=>"jadavpur university",
#"field"=>"computer science",
#"year"=>2016
})
=end
