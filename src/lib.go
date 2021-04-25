package main

import (
	"C"
	"bytes"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"sync"
)

type Request struct {
	Method string `json:"method"`
	URI    string `json:"uri"`
	Body   string `json:"body"`
}

type Response struct {
	Status int    `json:"status"`
	Body   string `json:"body"`
}

//export multihttp
func multihttp(ch *C.char, max int) *C.char {
	var requests []Request
	if err := json.Unmarshal([]byte(C.GoString(ch)), &requests); err != nil {
		log.Fatal(err)
	}

	var resps []Response
	conn := make(chan bool, max)
	wg := &sync.WaitGroup{}
	mutex := &sync.Mutex{}

	for _, request := range requests {
		wg.Add(1)
		conn <- true

		go func(r Request) {
			defer wg.Done()

			req, err := http.NewRequest(
				r.Method,
				r.URI,
				bytes.NewBuffer([]byte(r.Body)),
			)
			if err != nil {
				log.Fatal(err)
			}

			// TODO: Header settings

			client := &http.Client{}
			resp, err := client.Do(req)
			if err != nil {
				log.Fatal(err)
			}

			defer resp.Body.Close()

			byteArray, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				log.Fatal(err)
			}

			mutex.Lock()
			resps = append(resps, Response{Status: resp.StatusCode, Body: string(byteArray)})
			mutex.Unlock()

			<-conn
		}(request)
	}

	wg.Wait()

	json, err := json.Marshal(resps)
	if err != nil {
		log.Fatal(err)
	}

	return C.CString(string(json))
}

func main() {}
