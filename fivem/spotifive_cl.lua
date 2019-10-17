CurrentPlayBack = {
    title = "",
    timestamp = "",
    duration = "",
    artists = {}
}

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

--test

TriggerEvent("SpotiFive:CurrentPlaybackCallback", "nigger", 10000, 20000, {"nigger"})

CreateThread(
    function()
        while true do
            Wait(0)
            SetTextFont(1)
            SetTextProportional(1)
            SetTextScale(0.0, 0.3)
            SetTextColour(255, 204, 204, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 150)
            SetTextDropshadow()
            SetTextOutline()
            AddTextEntry("SPOTIFIVE_PLAYBACK1", "Currently Playing: " .. CurrentPlayBack.title)
            SetTextEntry("SPOTIFIVE_PLAYBACK1")
            DrawText(0.9, 0.05)
        end
    end
)

CreateThread(
    function()
        while true do
            Wait(5000)
            TriggerServerEvent("SpotiFive:GetCurrentPlayback")
        end
    end
)
