module.exports.setUp = (app, con)=>{
    app.get('/', (req, res) => res.send('Hello World!'))
}