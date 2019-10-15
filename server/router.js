const SpotifyAuthentication = require('spotify-authentication');
const spotifyAuthentication = new SpotifyAuthentication();

module.exports.setUp = (app, con) => {
    app.get('/', (req, res) => res.render('index',{success:(req.query.success == 'true'), message:req.query.message}))

    app.get('/spotify/auth', (req, res) => {
        spotifyAuthentication.setKeys(process.env.SPOTIFY_CLIENT_ID, process.env.SPOTIFY_CLIENT_SECRET);
        spotifyAuthentication.setRedirectUri(process.env.APP_PROTOCOL + process.env.APP_HOST + "/spotify/auth/return");
        var url = spotifyAuthentication.createAuthorizeURL('playlist-read-private playlist-modify-private playlist-modify-public playlist-read-collaborative user-modify-playback-state user-read-currently-playing user-read-playback-state user-top-read user-read-recently-played app-remote-control streaming user-read-email user-read-private user-follow-read user-follow-modify user-library-modify user-library-read', req.query.steam, true || 'showDialog').href
        res.redirect(url)
    })

    app.get('/spotify/auth/return', (req, res) => {
        spotifyAuthentication.authorizationCodeGrant(req.query.code)
            .then((result) => {
                con.query("INSERT IGNORE INTO accounts (steam, access_token, refresh_token) VALUES (?,?,?) ",[req.query.state, result.access_token, result.refresh_token],(err, result)=>{
                    if (err) {res.redirect("/?message=" + encodeURIComponent("Something went wrong while adding the entry to the database.") + "&success=false"); console.error(err); return;};
                    res.redirect("/?message=" + encodeURIComponent("Account linked successfully, you can now use SpotiFive Reload!")+ "&success=true")
                })
            }, console.error);
    })
}