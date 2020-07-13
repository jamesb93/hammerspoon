lib = {}

lib.insert = function(str1, str2, pos)
    return str1:sub(1,pos)..str2..str1:sub(pos+1)
end

return lib