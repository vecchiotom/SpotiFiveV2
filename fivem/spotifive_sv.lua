RegisterCommand("play", function(source, args, rawCommand)
    local id = getID(1, source)
    SpotiFive.Play(true,{"spotify:track:3V8UKqhEK5zBkBb6d6ub8i", "spotify:track:7thTA3hqO2MgOlzo0rPInX"}, id)
end, false)

function getID(type, source)
    for k,v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(tostring(v), 1, string.len("steam:")) == "steam:" and (type == "steam" or type == 1) then
            return v
        elseif string.sub(tostring(v), 1, string.len("license:")) == "license:" and (type == "license" or type == 2) then
            return v
        elseif string.sub(tostring(v), 1, string.len("ip:")) == "ip:" and (type == "ip" or type == 3) then
            return v
        end
    end
    return nil
end