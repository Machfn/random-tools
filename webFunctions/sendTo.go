package main
import (
	"fmt"
	"bytes"
	"time"
	"io"
	"net/http"
	"os"
	"strings"
)
/* 
Simple Cli tool to send JSON post requests and get request to servers for testing purposes
Usage:
	sendTo get [webAddress] -> prints the response from the web address (web address must be given with http:// or https://)
	sendTo post [webAddress] [jsonPath] -> sends post data and prints the response (web address must be given with http:// or https://)
*/
func main() {
	args := os.Args[1:]
	//fmt.Println(args)
	if (len(args) < 2) {
		fmt.Println("Not enough arguements given")
	} else if (len(args) < 3 && strings.ToLower(args[0]) == "post") {
		fmt.Println("Not Enough Arguments")
		os.Exit(1)
	} else if (args[0] == "get") {
		resp, err := http.Get(args[1])
		if err != nil {
			fmt.Printf("Error making get request: %s \n", err)
			os.Exit(1)
		}
		defer resp.Body.Close()

		fmt.Printf("Status: %s \n", resp.Status)
		body, err := io.ReadAll(resp.Body)
		if err != nil {
			fmt.Printf("Error reading response body: %s \n", err)
			os.Exit(1)
		}
		fmt.Printf("Response Body: \n %s \n", body)
	} else if (args[0] == "post") {
		postBody, err := os.ReadFile(args[2])
		if err != nil { fmt.Printf("Error opening json file: %s \n", err) }
		rBody := bytes.NewBuffer(postBody)
		client := &http.Client{Timeout: 10 * time.Second}

		req, err := http.NewRequest("POST", args[1], rBody)
		if err != nil {
			fmt.Printf("Error generating request: %s \n", err)
			os.Exit(1)
		}

		req.Header.Set("Content-Type", "application/json")
		req.Header.Set("Authorization", "user")

		resp, err := client.Do(req)
		if err != nil {
			fmt.Printf("Error sending request: %s \n", err)
			os.Exit(1)
		}
		defer resp.Body.Close()

		body, err := io.ReadAll(resp.Body)
		if err != nil {
			fmt.Printf("Error reading response body: %s \n", err)
			return
		}
		fmt.Printf("Status: %d \n", resp.StatusCode)
		fmt.Printf("Response: %s \n", body)
	}
		
}
