package db

import (
	// "log"
	"os"
	"strings"
	"fmt"
	"time"

	"github.com/bgpat/api/models"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"github.com/serenize/snaker"
)

func Connect() *gorm.DB {
	host := os.Getenv("DATABASE_HOST")
	user := os.Getenv("DATABASE_USER")
	dbname := os.Getenv("DATABASE_NAME")
	password := os.Getenv("DATABASE_PASSWORD")
	args := fmt.Sprintf(
		"host=%s user=%s dbname=%s sslmode=disable password=%s",
		host,
		user,
		dbname,
		password)
	db, err := gorm.Open("postgres", args)
	for retry := 1; err != nil; db, err = gorm.Open("postgres", args) {
		// log.Fatalf("Got error when connect database, the error is '%v'", err)
		time.Sleep(time.Duration(retry) * time.Second)
		retry <<= 1
	}
	db.LogMode(false)
	if gin.IsDebugging() {
		db.LogMode(true)
	}

	if os.Getenv("AUTOMIGRATE") == "1" {
		db.AutoMigrate(
			&models.Email{},
			&models.User{},
		)
	}
	return db
}

func DBInstance(c *gin.Context) *gorm.DB {
	return c.MustGet("DB").(*gorm.DB)
}

func SetPreloads(preloads string, db *gorm.DB) *gorm.DB {
	if preloads == "" {
		return db
	}

	for _, preload := range strings.Split(preloads, ",") {
		var a []string

		for _, s := range strings.Split(preload, ".") {
			a = append(a, snaker.SnakeToCamel(s))
		}

		db = db.Preload(strings.Join(a, "."))
	}

	return db
}
