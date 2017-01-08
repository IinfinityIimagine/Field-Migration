#!/usr/bin/ruby

def kcluster3(data, metric)
    num=0
    max=0
    min=0
    
    data.each { |value|
        num = num + 2**value[metric]
        max=2**value[metric] if(2**value[metric]>max)
        min=2**value[metric] if(2**value[metric]<min)
    }
    num=num/data.size() if(data.size != 0)
    count=0
    clusterh={"oldmean"=>0, "mean"=>max}
    clusterm={"oldmean"=>0, "mean"=>num}
    clusterl={"oldmean"=>0, "mean"=>min}
    begin
        count=count+1
        clusterh["values"]=Array.new()
        clusterm["values"]=Array.new()
        clusterl["values"]=Array.new()
        
        data.each { |value|
            one = (2**value[metric]-clusterh["mean"]).abs
            two = (2**value[metric]-clusterm["mean"]).abs
            three = (2**value[metric]-clusterl["mean"]).abs
            (one<two ? (one<three ? clusterh : clusterl) : (two<three ? clusterm : clusterl))["values"].push(value)
        }
        
        num=0
        clusterh["values"].each { |value|
            num = num + 2**value[metric]
        }
        clusterh["oldmean"]=clusterh["mean"]
        clusterh["mean"]=num/clusterh["values"].size if(clusterh["values"].size!=0)
        
        num=0
        clusterm["values"].each { |value|
            num = num + 2**value[metric]
        }
        clusterm["oldmean"]=clusterm["mean"]
        clusterm["mean"]=num/clusterm["values"].size if(clusterm["values"].size!=0)
        
        num=0
        clusterl["values"].each { |value|
            num = num + 2**value[metric]
        }
        clusterl["oldmean"]=clusterl["mean"]
        clusterl["mean"]=num/clusterl["values"].size if(clusterl["values"].size!=0)
        
        #puts clusterh["mean"].to_s + " " + clusterm["mean"].to_s + " " + clusterl["mean"].to_s + " " + count.to_s
    end until (clusterh["oldmean"]==clusterh["mean"] and clusterm["oldmean"]==clusterm["mean"] and clusterl["oldmean"]==clusterl["mean"])
    #return clusterh["values"], clusterm["values"], clusterl["values"]
    clusterh["values"]
end
