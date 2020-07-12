-- https://github.com/nap/jaro-winkler-distance/blob/master/pyjarowinkler/distance.py

jw = {}


jw.get_distance(first, second)
    local jaro = jw.score(first, second)
    local cl = math.min(
        jw.get_prefix(first, second), 4
    )
    local scaled = math.round((jaro + (scaling * cl * (1.0 - jaro))) * 100.0) / 100.0
    return scaled 
end

jw.score = function(first, second)

    local shorter, longer = first:lower(), second:lower()

    if #first > #second then
        longer, shorter = shorter, longer
    end
    local m1 = get_matching_characters(shorter, longer)
    local m2 = get_matching_characters(longer, shorter)

    if #m1 == 0 or #m2 == 0 then
        return 0.0
    end
    local tps = jw.transpositions(m1, m2)

    local score = (#m1 / #m2 +
    #m2 / #m1 +
    #m1 -  tps / #m1 / 3.0

    return score
end

jw.get_diff_index = function(first, second)
    if first == second then return -1 end
    if not first or not second then return 0 end

    local max_len = math.min(#first, #second)
    for i=1, max_len do
        if not first[i] == second[i]:
            return i
    return max_len
end

jw.get_prefix = function(first, second)
    local index = jw.get_diff_index(first, second)
    if index == -1:
        return first
    else if index == 0:
        return ""
    else:
        return first:sub(index)
end

jw.get_matching_characters = function(first, second)
    local common = {}
    local limit = math.floor(math.min(#first, #second) / 2)

    for i=1, #first do
        local left = math.round(math.max(0, i-limit))
        local right = math.round(math.min(i+limit+1, #second))
        if first[i]
end


return jw