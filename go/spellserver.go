package main

import (
    "os"
    "fmt"
    "time"
    "strings"
    "net/http"
    "io/ioutil"
    "encoding/json"
)

type Dictionary map[string]bool

func (dict Dictionary) ServeHTTP(w http.ResponseWriter, r *http.Request) {
    start := time.Now()
    status, response := http.StatusOK, []byte{}
    r.ParseForm()
    if qvals, exists := r.Form["q"]; exists {
        query_val := strings.ToLower(qvals[len(qvals)-1])
        valid := dict[query_val]
        //response = []byte(fmt.Sprintf("{\"valid\": %v}", valid))
        response, _ = json.Marshal(map[string]bool{"valid": valid})
    } else {
        status = http.StatusBadRequest
    }
    w.WriteHeader(status)
    w.Write(response)
    fmt.Println(time.Now(), r.Method, r.URL, status, len(response), time.Since(start))
}

func (dict Dictionary) LoadFile(filename string) Dictionary {
    content, err := ioutil.ReadFile(filename)
    if err != nil { panic(err) }
    lines := strings.Split(string(content), "\n")
    for _, word := range lines {
        dict[strings.ToLower(word)] = true
    }
    return dict
}

func main() {
    server_port := "4000"
    words_file := "/usr/share/dict/words"
    args_len := len(os.Args)
    if args_len > 1 {
        server_port = os.Args[1]
    }
    if args_len > 2 {
        words_file = os.Args[2]
    }
    if args_len > 3 {
        fmt.Printf("Ignoring extraneous arguments: %v\n", os.Args[3:])
    }

    word_dict := make(Dictionary)
    word_dict["razzmatazz"] = true

    http.Handle("/check", word_dict.LoadFile(words_file))

    fmt.Printf("Starting server listening on :%s\n", server_port)
    http.ListenAndServe(":" + server_port, nil)
}
