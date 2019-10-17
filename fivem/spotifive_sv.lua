RegisterCommand(
    "play",
    function(source, args, rawCommand)
        local id = getID(1, source)
        local uris = stringSplit(string.sub(rawCommand, 6), ",")
        SpotiFive.Play(uris, id)
    end,
    false
)

RegisterCommand(
    "pause",
    function(source, args, rawCommand)
        local id = getID(1, source)
        SpotiFive.Pause(id)
    end,
    false
)

RegisterCommand(
    "volume",
    function(source, args, rawCommand)
        local id = getID(1, source)
        if (args[1]) then
            SpotiFive.Volume(id, {args[1]})
        end
    end,
    false
)

RegisterCommand(
    "testsp",
    function(source, args, rawCommand)
        TriggerClientEvent("SpotiFive:CurrentPlaybackCallback", source, "fucking shit", 100000, 100000, {"nigger"})
    end,
    false
)


function getID(type, source)
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
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

function stringSplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end
