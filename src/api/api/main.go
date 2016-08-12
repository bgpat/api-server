package main

import (
	"github.com/bgpat/api/db"
	"github.com/bgpat/api/server"
)

// main ...
func main() {
	database := db.Connect()
	s := server.Setup(database)
	s.Run(":8080")
}
