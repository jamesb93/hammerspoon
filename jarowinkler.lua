-- https://github.com/nap/jaro-winkler-distance/blob/master/pyjarowinkler/distance.py
require("lib")
jw = {}


jw.get_distance = function(first, second)
    local jaro = jw.score(first, second)
    local cd = jw.get_prefix(first, second)
    local cl = math.min(#cd, 4)
    local scaled = math.floor(((jaro + (0.4 * cl * (1.0 - jaro))) * 100.0) +0.5) / 100.0
    return scaled 
end

jw.score = function(first, second)
    local shorter, longer = first:lower(), second:lower()

    if #first > #second then
        longer, shorter = shorter, longer
    end

    local m1 = jw.get_matching_characters(shorter, longer)
    local m2 = jw.get_matching_characters(longer, shorter)

    if #m1 == 0 or #m2 == 0 then
        return 0.0
    end
    local tps = jw.transpositions(m1, m2)

    local score = (#m1 / #m2 + #m2 / #m1 + #m1 -  tps / #m1) / 3.0

    return score
end

jw.get_diff_index = function(first, second)
    if first == second then return -1 end
    if not first or not second then return 0 end

    local max_len = math.min(#first, #second)
    for i=1, max_len do
        if not first[i] == second[i] then
            return i
        end
    end

    return max_len
end

jw.get_prefix = function(first, second)
    local index = jw.get_diff_index(first, second)
    if index == -1 then 
        return first 
    elseif index == 0 then
        return ""
    else
        return first:sub(index)
    end
end

jw.get_matching_characters = function(first, second)
    local common = ""
    local limit = math.floor(math.min(#first, #second) / 2)
    print(limit)
    local tabled_string = {}
    first:gsub(".",function(c) table.insert(tabled_string,c) end)

    for i=1, #first do
        local left = math.floor(math.max(0, i-limit) + 0.5)
        local right = math.floor(math.min(i+limit+1, #second) + 0.5)
        local f = second:sub(left, right)
        local s = tabled_string[i]
        if s:match(f) then
            common = common..s
            second = lib.insert("*", second, i)
        end
    end
    print(common)
    return common
end

jw.transpositions = function(first, second)
    local transpositions = 0
    local small, large = str1, str2
    if #small > #large then large, small = small, large end
    for i=1, #small do
        local a, b = small[i], large[i]
        if a ~= b then
            transpositions = transpositions + 1
        end
    end
    transpositions = math.floor(transpositions / 2.0)
    return transpositions
end

return jw