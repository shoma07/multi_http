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

//export multi_http
func multi_http(reqJson *C.char, max int) *C.char {
	var requests []Request
	if err := json.Unmarshal([]byte(C.GoString(reqJson)), &requests); err != nil {
		log.Fatal(err)
	}

	var responses []Response
	maxConnection := make(chan bool, max)
	wg := &sync.WaitGroup{}
	mutex := &sync.Mutex{}

	for _, request := range requests {
		wg.Add(1)
		maxConnection <- true
		go func(request Request) {
			defer wg.Done()

			req, err := http.NewRequest(
				request.Method,
				request.URI,
				bytes.NewBuffer([]byte(request.Body)),
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
			responses = append(responses, Response{Status: resp.StatusCode, Body: string(byteArray)})
			mutex.Unlock()

			<-maxConnection
		}(request)
	}
	wg.Wait()

	resJson, err := json.Marshal(responses)
	if err != nil {
		log.Fatal(err)
	}
	return C.CString(string(resJson))
}

func main() {}
