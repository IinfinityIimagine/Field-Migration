#!/usr/bin/ruby

def getFosHash
    fos = Hash.new
    File.open("L0L1FosEmbeddings.tsv").each_line { |line|
        tell=line.split
        fld=tell[0]
        tell.shift
        fos[fld]=tell
    }
    fos
end

getFosHash
