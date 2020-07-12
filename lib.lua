lib = {}

lib.levenshtein = function(str1, str2)
    -- Take the distance between two strings
    local len1, len2 = #str1, #str2
    local char1, char2, distance = {}, {}, {}
    str1:gsub('.', function (c) table.insert(char1, c) end)
    str2:gsub('.', function (c) table.insert(char2, c) end)
    for i = 0, len1 do distance[i] = {} end
    for i = 0, len1 do distance[i][0] = i end
    for i = 0, len2 do distance[0][i] = i end
    for i = 1, len1 do
        for j = 1, len2 do
            distance[i][j] = math.min(
                distance[i-1][j  ] + 1,
                distance[i  ][j-1] + 1,
                distance[i-1][j-1] + (char1[i] == char2[j] and 0 or 1)
                )
        end
    end
    return distance[len1][len2]
end

lib.damleven = function( s, t, lim )
    -- A fairly light implementation of the Damerau-Levenshtein distance algo
    -- Thank you internets https://gist.github.com/Nayruden/427389
    local s_len, t_len = #s, #t -- Calculate the sizes of the strings or arrays
    if lim and math.abs( s_len - t_len ) >= lim then -- If sizes differ by lim, we can stop here
        return lim
    end
    
    -- Convert string arguments to arrays of ints (ASCII values)
    if type( s ) == "string" then
        s = { string.byte( s, 1, s_len ) }
    end
    
    if type( t ) == "string" then
        t = { string.byte( t, 1, t_len ) }
    end
    
    local min = math.min -- Localize for performance
    local num_columns = t_len + 1 -- We use this a lot
    
    local d = {} -- (s_len+1) * (t_len+1) is going to be the size of this array
    -- This is technically a 2D array, but we're treating it as 1D. Remember that 2D access in the
    -- form my_2d_array[ i, j ] can be converted to my_1d_array[ i * num_columns + j ], where
    -- num_columns is the number of columns you had in the 2D array assuming row-major order and
    -- that row and column indices start at 0 (we're starting at 0).
    
    for i=0, s_len do
        d[ i * num_columns ] = i -- Initialize cost of deletion
    end
    for j=0, t_len do
        d[ j ] = j -- Initialize cost of insertion
    end
    
    for i=1, s_len do
        local i_pos = i * num_columns
        local best = lim -- Check to make sure something in this row will be below the limit
        for j=1, t_len do
            local add_cost = (s[ i ] ~= t[ j ] and 1 or 0)
            local val = min(
                d[ i_pos - num_columns + j ] + 1,                               -- Cost of deletion
                d[ i_pos + j - 1 ] + 1,                                         -- Cost of insertion
                d[ i_pos - num_columns + j - 1 ] + add_cost                     -- Cost of substitution, it might not cost anything if it's the same
            )
            d[ i_pos + j ] = val
            
            -- Is this eligible for tranposition?
            if i > 1 and j > 1 and s[ i ] == t[ j - 1 ] and s[ i - 1 ] == t[ j ] then
                d[ i_pos + j ] = min(
                    val,                                                        -- Current cost
                    d[ i_pos - num_columns - num_columns + j - 2 ] + add_cost   -- Cost of transposition
                )
            end
            
            if lim and val < best then
                best = val
            end
        end
        
        if lim and best >= lim then
            return lim
        end
    end
    
    return d[#d]
end

lib.weightearly = function(query, appname, limit)
    -- Returns a scalar to modify the distance becased on early matches.
    -- This will help to make immediate matches more heavily preferenced
    local limit = limit or 5
    local a = query:sub(0, limit)
    local b = appname:sub(0, limit)
    a = a:lower()
    b = b:lower()
    local ta = {}
    local tb = {}
    a:gsub(".",function(c) table.insert(ta,c) end)
    b:gsub(".",function(c) table.insert(tb,c) end)
    local count = 0
    for i=1, #ta do
        if ta[i] == tb[i] then 
            count = count + 1 
        else
            return count+1
        end
    end
    return count+1
end

lib.insert = function(str1, str2, pos)
    return str1:sub(1,pos)..str2..str1:sub(pos+1)
end

return lib