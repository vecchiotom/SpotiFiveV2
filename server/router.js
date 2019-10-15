const SpotifyAuthentication = require('spotify-authentication');
const spotifyAuthentication = new SpotifyAuthentication();
var SpotifyWebApi = require('spotify-web-api-node');

// credentials are optional
var spotifyApi = new SpotifyWebApi({
    clientId: process.env.SPOTIFY_CLIENT_ID,
    clientSecret: process.env.SPOTIFY_CLIENT_SECRET,
});

module.exports.setUp = (app, con) => {
    app.get('/', (req, res) => res.render('index', {
        success: (req.query.success == 'true'),
        message: req.query.message
    }))

    app.get('/spotify/auth', (req, res) => {
        spotifyAuthentication.setKeys(process.env.SPOTIFY_CLIENT_ID, process.env.SPOTIFY_CLIENT_SECRET);
        spotifyAuthentication.setRedirectUri(process.env.APP_PROTOCOL + process.env.APP_HOST + "/spotify/auth/return");
        var url = spotifyAuthentication.createAuthorizeURL('playlist-read-private playlist-modify-private playlist-modify-public playlist-read-collaborative user-modify-playback-state user-read-currently-playing user-read-playback-state user-top-read user-read-recently-played app-remote-control streaming user-read-email user-read-private user-follow-read user-follow-modify user-library-modify user-library-read', req.query.steam, true || 'showDialog').href
        res.redirect(url)
    })

    app.get('/spotify/auth/return', (req, res) => {
        spotifyAuthentication.authorizationCodeGrant(req.query.code)
            .then((result) => {
                con.query("INSERT IGNORE INTO accounts (steam, access_token, refresh_token) VALUES (?,?,?) ", [req.query.state, result.access_token, result.refresh_token], (err, result) => {
                    if (err) {
                        res.redirect("/?message=" + encodeURIComponent("Something went wrong while adding the entry to the database.") + "&success=false");
                        console.error(err);
                        return;
                    };
                    res.redirect("/?message=" + encodeURIComponent("Account linked successfully, you can now use SpotiFive Reload!") + "&success=true")
                })
            }, console.error);
    })

    app.get('/fivem/request', (req, res) => {

        refreshAccessToken(con, req.query.id, res, (access_token) => {
            var info = (req.query.info) ? JSON.parse(req.query.info) : []
            console.log(info)
            spotifyApi.setAccessToken(access_token);

            switch (req.query.command) {
                case "play":
                    console.log("play command received for user: " + req.query.id)
                    spotifyApi.play((info[0] == "track") ? {
                            "uris": arrayRemove(info, "track")
                        } : {
                            "context_uri": info[0]
                        })
                        .then(() => {
                            res.json({})
                        })
                        .catch((err) => {
                            res.status(500)
                            res.json({
                                error: err.message
                            })
                        })

                    break;

                default:
                    console.log("invalid command received, ignoring.")
                    res.json({
                        error: "invalid command"
                    })
                    break;
            }
        })
    })
}

const refreshAccessToken = (con, id, res, cb) => {
    var token
    con.query('SELECT * FROM accounts WHERE steam=? LIMIT 1', [id], (err, result) => {
        if (err) {
            res.json({
                error: "an error occurred while querying the database."
            });
            console.error("an error occurred while querying the database. (select refresh token)", err.message)
            return;
        }
        if (!result) {
            res.json({
                notfound: true
            });
            return;
        }

        //spotifyAuthentication.setRefreshToken(res[0].refresh_token);
        spotifyAuthentication.setKeys(process.env.SPOTIFY_CLIENT_ID, process.env.SPOTIFY_CLIENT_SECRET);
        spotifyAuthentication.refreshAccessToken(result[0].refresh_token).then((response) => {
            con.query("UPDATE accounts SET access_token = ? WHERE steam = ?", [response.access_token, id], (err, result) => {
                if (err) {
                    res.json({
                        error: "an error occurred while querying the database."
                    });
                    console.error("an error occurred while querying the database. (update access token)", err.message)
                    return;
                }
                token = response.access_token
                cb(token)
            })
        }, console.error);
    })
}

function arrayRemove(arr, value) {

    return arr.filter(function(ele){
        return ele != value;
    });
 
 }