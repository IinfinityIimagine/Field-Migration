#!/usr/bin/ruby
require "./APIcall"
require "./cluster"
require "./FieldID"
require "json"

=begin
    #pseudocode
    for each turing award winner (from file)
        call api for the winner around the year (data in file)
        for each paper
            call api for authors in same institition at same time, similar fields (to do)
            for each author
                add authors to list, with citation counts
        make 3-cluster (cluster_test.rb)
        print uppermost group
=end

=begin
    turing awardee A for field F
    #problem 1
    find out earliest paper of A that was in field F (obviously there is one) => PF
    find out if earliest paper of A was in field F => PE
    #problem 2
    from PE to PF, find working place W
    check other people working in field F at W =>I
    run cluster of I => C
    check if A collaborated with people in C, at each location W
=end

#=begin
File.open("rep.txt").each_line { |line|

    
    tell=line.split
    awardee = {"name"=>(tell[1]+" "+tell[2]).downcase, "year"=>tell[0].to_i}
    awardee["file"]="candidate.txt"
    3.times { tell.shift }
    #data=getFromAcademic(awardee) #actual code
    data=JSON.parse(File.read("candidate.txt"))["entities"] #for now
    
    
    awardee["field"]=parseField(tell) #placeholder
    awardee["field"]=tell.join(" ") #less generic field
    
    
    data=data.sort { |x, y| x["Y"]<=>y["Y"] }
    earliest = data[0]
    earliestInField =  nil
    affiliations = Hash.new
    data.each { |paper|
        begin
            #puts paper
            if affiliations[ paper["Y"] ] == nil
                temp = nil  
                paper["AA"].each { |author|
                    if Regexp.new(awardee["name"].split.join(".*")) =~ author["AuN"] #regex??
                        temp=author
                        break
                    end
                }
                affiliations[ paper["Y"] ] = temp["AfN"]
            end
            
            if paper["F"][0]["FN"] == awardee["field"]
            #if paper["F"][0]["FN"] == earliest["F"][0]["FN"]
                earliestInField=paper
                break
            end
        rescue Exception=>e
            next
        end
    }
    
    
    puts "Earliest : "+earliest["Ti"]+" "+earliest["Y"].to_s
    puts "Earliest in field : "+earliestInField["Ti"]+" "+earliestInField["Y"].to_s
    
    
    peers=nil
    #(earliest["Y"] .. earliestInField["Y"]).each { |year| puts year.to_s + "   " + affiliations[year] if affiliations[year] != nil }
    theField = [awardee["field"]]
    earliestInField["F"].each { |fld|
        theField.push(fld["FN"])
    }
    theField.uniq!
    affiliations.each { |year, place|
        peers = { "year"=>year, "place"=>place, "field"=> theField }
        peers["file"]="unclustered.txt" #for now
        #peers = getFromAcademic(peers)
        peers = JSON.parse(File.read("unclustered.txt"))["entities"]
=begin        peers.each { |pub|
            puts pub["Ti"] + "      " + pub["logprob"].to_s
            STDIN.getc
=end        }
        peers= kcluster3(peers, "logprob")
        
        puts "xxxxxxxxxxxxxxxxx"
        puts
        puts
        collab = Array.new
        peers.each { |pub|
            print "X:::"
            pub["AA"].each { |auth|
                if Regexp.new(awardee["name"].split.join(".*")) =~ auth["AuN"] #regex??
                    print "\b\b\b\bO:::" #check if awardee["name"] is in the clustered papers' AA.AuN
                    break
                end
            }
            pub["AA"].each { |auth|
                unless Regexp.new(awardee["name"].split.join(".*")) =~ auth["AuN"] #regex??
                    collab.push(auth["AuN"])
                end
            }
            puts pub["Ti"] + "      " + pub["logprob"].to_s
            
        }
        collab.uniq!
        collab.each { |cbr|
            didThey = { "name"=> [author["name"], cbr], 
                        "year"=>year, 
                        "place"=>place, 
                        "field"=>theField, 
                        "stddev"=>5 }
            didThey = getFromAcademic(didThey)
            didThey.each { |coAuthrs|
                #display something?
            }

        }
        break #only one peer cluster for now
    }
    
    break #only 1 awardee for now
}
#=end
