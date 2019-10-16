SpotiFive = {}

local function _encodeChar(chr)
	return string.format("%%%X",string.byte(chr))
end

local function _encodeString(str)
	local output, t = string.gsub(str,"[^%w]",_encodeChar)
	return output
end

function _getSteamId64FromHex(hex_id)
	return tonumber(hex_id, 16)
end

function SpotiFive.Play(track, uris, id)

    id = _getSteamId64FromHex(string.sub(id, 7))

    if track then table.insert(uris, 1, "track") end
    uris = json.encode(uris)


    local url = Config.host.."/fivem/request?command=play&id="..id.."&info=".._encodeString(uris)
    PerformHttpRequest(url, function (errorCode, resultData, resultHeaders)end)
end

function SpotiFive.Pause(id)

    id = _getSteamId64FromHex(string.sub(id, 7))

    local url = Config.host.."/fivem/request?command=pause&id="..id
    PerformHttpRequest(url, function (errorCode, resultData, resultHeaders)end)
end