#!/usr/bin/ruby
require "./APIcall"

File.open("rep.txt", "w") do |newf|
    File.open("TuringWinners.txt").each_line { |line|
        i=0
        tell=line.split
        awardee = {"name"=>(tell[1]+" "+tell[2]).downcase, "year"=>(tell[0].to_i)-3, "stddev"=>3}
        home=getFromAcademic(awardee)
        #home.sort { |x, y| x["logprob"]<=>y["logprob"] }
        begin
            awardee["field"]=home[i]["F"][0]["FN"]
        rescue Exception=>e
            next if i>home.size
            i+=1
            retry
        end
        newf.write (awardee["year"]+3).to_s + " " + awardee["name"] + " " + awardee["field"] + "\n"
    }
end
