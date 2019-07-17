const express = require("express");
var path = require("path");

const server = express();

var sqlite3 = require("sqlite3").verbose();
var db;
if (process.platform === "darwin") {
  db = new sqlite3.Database(
    path.resolve(__dirname, "..", "..", "..", "..", "..", "app.db")
  );
}
if (process.platform === "linux") {
  db = new sqlite3.Database(
    path.resolve(__dirname, "..", "..", "..", "..", "app.db")
  );
}

db.serialize(function() {
  db.run("CREATE TABLE IF NOT EXISTS lorem (info TEXT)");

  var stmt = db.prepare("INSERT INTO lorem VALUES (?)");
  for (var i = 1; i < 11; i++) {
    stmt.run("Ipsum " + i);
  }
  stmt.finalize();
});
server.get("/", function(req, res) {
  var obj = {};

  db.serialize(function() {
    db.each(
      "SELECT rowid AS id, info FROM lorem",
      function(err, row) {
        obj[row.id] = row.info;
      },
      function() {
        console.log(obj);
        res.send(obj);
      }
    );
  });
});

server.get("/index", function(req, res) {
  res.sendFile("index.html", { root: __dirname });
});

server.listen(8080);
