package main

import (
	"fmt"
	"net/rpc"
	"flag"
	"time"
	"net"
)

var N int

func checkError(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {
	// read arguments
	portPtr := flag.Int("p", 9000, "# start port")
	NPtr := flag.Int("n", 2, "total number of processes")
	flag.Parse()
	rootPort := *portPtr
	N = *NPtr
	// initialize
	fmt.Println("")
	fmt.Println("🏁 Client started 🏁")
	time.Sleep(time.Second)
	head, err := rpc.Dial("tcp",fmt.Sprintf("localhost:%d",(rootPort+1)))
	checkError(err)
	hd,_ := net.ResolveTCPAddr("tcp",fmt.Sprintf("localhost:%d",rootPort+1))
	fmt.Println("Client connected to head at",hd)
	tail, err := rpc.Dial("tcp",fmt.Sprintf("localhost:%d",(rootPort+N)))
	checkError(err)
	tl,_ := net.ResolveTCPAddr("tcp",fmt.Sprintf("localhost:%d",rootPort+N))
	fmt.Println("Client connected to tail at",tl)
	args := &Todo{Task:"test",Completed:false,Commited:false}
	var reply struct{}
	head.Call("TodoStorage.Put",args,&reply)
	fmt.Println("📩 reply to put:",reply)
	args1 := &Todo{Task:"test1",Completed:false,Commited:false}
	head.Call("TodoStorage.Put",args1,&reply)
	fmt.Println("📩 reply to put:",reply)
	time.Sleep(time.Second)
	var greply map[string]Todo
	tail.Call("TodoStorage.Get",args,&greply)
	fmt.Println("📩 reply to get:",greply)
	fmt.Println("🛑 End 🛑")
}

type Todo struct {
	Task      string `json:"task"`
	Completed bool   `json:"completed"`
	Commited  bool   `json:"commited"`
}