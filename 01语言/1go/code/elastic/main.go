package main

import (
	"gopkg.in/olivere/elastic.v5"
	//"github.com/olivere/elastic"
	"time"
	"context"
	"fmt"
	"os"
	"log"
)

var client *elastic.Client
func cfgInit() {
	var err error
	client, err = elastic.NewClient(
		elastic.SetURL("http://192.168.37.130:9200"),
		elastic.SetSniff(false),
		elastic.SetHealthcheckInterval(10*time.Second),
		elastic.SetGzip(true),
		elastic.SetErrorLog(log.New(os.Stderr, "ELASTIC ", log.LstdFlags)),
		elastic.SetInfoLog(log.New(os.Stdout, "", log.LstdFlags)),
	)

	if err != nil {
		panic(err.Error())
	}
}
type Tweet struct {
	User     string        `json:"user"`
	Message  string        `json:"message"`
	Retweets int           `json:"retweets"`
	Image    string        `json:"image,omitempty"`
	Created  time.Time     `json:"created,omitempty"`
	Tags     []string      `json:"tags,omitempty"`
	Location string        `json:"location,omitempty"`
}

//PUT1
func insert() {
	ctx := context.Background()
	tweet1 := Tweet{User: "olivere", Message: "Take Five", Retweets: 0}
	put1, err := client.Index().
			Index("twitter").
			Type("tweet").
			Id("1").
			BodyJson(tweet1).
			Do(ctx)

	if err != nil {
		panic(err)
		return
	}
	fmt.Printf("Indexed tweet %s to index %s, type %s\n", put1.Id, put1.Index, put1.Type)
}

func main() {
	cfgInit()
	//使用
	insert()
	//停止
	defer client.Stop()
}
