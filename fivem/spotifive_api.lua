SpotiFive = {}

local function _encodeChar(chr)
    return string.format("%%%X", string.byte(chr))
end

local function _encodeString(str)
    local output, t = string.gsub(str, "[^%w]", _encodeChar)
    return output
end

function _getSteamId64FromHex(hex_id)
    return tonumber(hex_id, 16)
end

function SpotiFive.Play(uris, id)
    id = _getSteamId64FromHex(string.sub(id, 7))

    uris = json.encode(uris)

    local url = Config.host .. "/fivem/request?command=play&id=" .. id .. "&info=" .. _encodeString(uris)
    PerformHttpRequest(
        url,
        function(errorCode, resultData, resultHeaders)
        end
    )
end

function SpotiFive.Pause(id)
    id = _getSteamId64FromHex(string.sub(id, 7))

    local url = Config.host .. "/fivem/request?command=pause&id=" .. id
    PerformHttpRequest(
        url,
        function(errorCode, resultData, resultHeaders)
        end
    )
end

function SpotiFive.Volume(id, info)
    id = _getSteamId64FromHex(string.sub(id, 7))

    info = json.encode(info)

    print(info)
    local url = Config.host .. "/fivem/request?command=volume&id=" .. id .. "&info=" .. _encodeString(info)
    PerformHttpRequest(
        url,
        function(errorCode, resultData, resultHeaders)
        end
    )
end

function SpotiFive.GetCurrentPlayback(id, cb)
    id = _getSteamId64FromHex(string.sub(id, 7))

    info = json.encode(info)

    local url = Config.host .. "/fivem/request?command=currentplayback&id=" .. id
    PerformHttpRequest(
        url,
        function(errorCode, resultData, resultHeaders)
            resultData = json.decode(resultData)

            local title = resultData.item.name
            local timestamp = _millisToMinutesAndSeconds(resultData.progress_ms)
            local duration = _millisToMinutesAndSeconds(resultData.item.duration_ms)
            local artists = {}

            for i, v in ipairs(resultData.item.artists) do
                table.insert(artists, v.name)
            end
            cb(title, timestamp, duration, json.encode(artists))
        end
    )
end

RegisterNetEvent("SpotiFive:GetCurrentPlayback")
AddEventHandler(
    "SpotiFive:GetCurrentPlayback",
    function()
        local source = source
        SpotiFive.GetCurrentPlayback(
            getID(1, source),
            function(title, timestamp, duration, artists)
                local source = source
                TriggerClientEvent("SpotiFive:GetCurrentPlayback", source, title, timestamp, duration, artists)
                print("trigger " .. source)
            end
        )
    end
)

function _millisToMinutesAndSeconds(millis)
    local minutes = math.floor(millis / 60000)
    local seconds = math.floor(((millis % 60000) / 1000), 0)
    return minutes .. ":" .. ((seconds < 10) and "0" or "") .. seconds
end

function _round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
