function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function shuffleTable( t )
 
    if ( type(t) ~= "table" ) then
        print( "WARNING: shuffleTable() function expects a table" )
        return false
    end
 
    local j
 
    for i = #t, 2, -1 do
        j = math.random( i )
        t[i], t[j] = t[j], t[i]
    end
    return t
end