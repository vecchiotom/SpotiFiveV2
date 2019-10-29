CurrentPlayBack = {
    title = "",
    timestamp = "",
    duration = "",
    artists = {}
}

function _tableToString(t, sep)
    local s = ""
    local _sep = ""
    for i,v in ipairs(t) do
        _sep = (i==1) and "" or sep
        s = s .. _sep .. v
    end
    return s
end

RegisterNetEvent("SpotiFive:CurrentPlaybackCallback")
AddEventHandler(
    "SpotiFive:CurrentPlaybackCallback",
    function(title, timestamp, duration, artists)
        CurrentPlayBack.title = title
        CurrentPlayBack.timestamp = timestamp
        CurrentPlayBack.duration = duration
        CurrentPlayBack.artists = artists
        print("updated info")
    end
)


CreateThread(
    function()
        while true do
            Wait(0)
            local artists = _tableToString(CurrentPlayBack.artists, ", ") or ""
            SetTextFont(1)
            SetTextProportional(1)
            SetTextScale(0.0, 0.55    )
            SetTextColour(255, 204, 204, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 150)
            SetTextDropshadow()
            SetTextOutline()
            AddTextEntry("SPOTIFIVE_PLAYBACK1", "Currently Playing: " .. CurrentPlayBack.title .. "\n by: " .. artists)
            SetTextEntry("SPOTIFIVE_PLAYBACK1")
            DrawText(0.75, 0.05)
        end
    end
)

CreateThread(
    function()
        while true do
            Wait(2000)
            TriggerServerEvent("SpotiFive:GetCurrentPlayback")
        end
    end
)
