package main

import (
	"flag"
	"fmt"
	"net"
	"time"
	"math/rand"
	"slices"
	"os"
)

type message struct {
	id     int     // message id
	time   []byte  // time of sending
	from   int     // last sender
	trace []byte   // trace of senders' id
	length int
}

var N int        // number of processes
var id int       // id of process
var basePort int // port of process
var M int        // number of messages
var K int        // gossip number
var TF = "15:04:05.999" // time format
var FORMAT = "[ %d | %s | %d | %s ]" // message format
var received []int // ids of received messages
var rid = 0 // number of received messages
var sent = true // did process send all messages

// function for panicking errors
func checkError(err error) {
	if err != nil {
		panic(err)
	}
}
func receive(addr *net.UDPAddr, fr int, out chan<- message) {
	// open listening port
	conn, err := net.ListenUDP("udp", addr)
	checkError(err)
	conn.SetDeadline(time.Now().Add(time.Second*time.Duration(M)))
	defer conn.Close()
	fmt.Println("  👂 Agent", id, "listening on", addr)
	fmt.Println()
	buffer := make([]byte, 1024)
	for {
		// read message
		mLen, err := conn.Read(buffer)
		checkError(err)
		// parse message
		rMsg := message{}
		fmt.Sscanf(string(buffer[:mLen]),FORMAT,&rMsg.id,&rMsg.time,&rMsg.from,&rMsg.trace)
		rMsg.length = (mLen)
		// remove already received message
		if slices.Contains(received,rMsg.id) {
			fmt.Println("  ❌ message",rMsg.id,"from",rMsg.from,"already received")
		} else {
			fmt.Println("  📩 ", string(buffer[:mLen]), "received on",fr)
			// mark message
			received[rid] = rMsg.id
			rid++
			// return message
			out <- rMsg
		}
	}
}

func send(addr *net.UDPAddr, msg message) {
	// open connection
	conn, err := net.DialUDP("udp", nil, addr)
	checkError(err)
	defer conn.Close()
	// create message
	sMsg := fmt.Sprintf(FORMAT,msg.id,msg.time,basePort,msg.trace)
	ml := len(sMsg)-2
	sMsg = sMsg[:ml] + "-" + fmt.Sprint(id) + sMsg[ml:]
	// send message
	_, err = conn.Write([]byte(sMsg))
	checkError(err)
	fmt.Println("  📨 ", sMsg, "from", msg.from, "sent to", addr)
}

func main() {
	// read arguments
	portPtr := flag.Int("p", 9000, "# start port")
	idPtr := flag.Int("id", 0, "# process id")
	NPtr := flag.Int("n", 2, "total number of processes")
	MPtr := flag.Int("m",1,"number of messages")
	KPtr := flag.Int("k",1,"gossip number")
	flag.Parse()
	rootPort := *portPtr
	id = *idPtr
	N = *NPtr
	M = *MPtr
	K = *KPtr
	// initialize basePort
	basePort = rootPort + 1 + id
	// initialize list of other ports
	otherPorts := make([]int,N-1)
	ind := 0
	for i:=0; i<N; i++ {
		if i!=id {
			otherPorts[ind] = rootPort+1+i
			ind++
		}
	}
	// initialize UDP addresses for other agents
	var err error
	remoteAddr := make([]*net.UDPAddr,N-1)
	for i,p := range otherPorts {
		remoteAddr[i], err = net.ResolveUDPAddr("udp", fmt.Sprintf("localhost:%d", p))
		checkError(err)
	}
	// initialize base UDP address
	baseAddr, err := net.ResolveUDPAddr("udp", fmt.Sprintf("localhost:%d", basePort))
	checkError(err)
	// initialize list of received messages
	received = make([]int,M)
	for i:=0; i<M; i++ {
		received[i]=-1
	}
	fmt.Println("🏁 Agent",id,"started 🏁")
	// if initial agent start emitting
	if id == 0 {
		// process id=0 "received" all messages
		for i:=0; i<M; i++ {
			received[i]=i
			rid++
		}
		sent = false
		go func() {
			// initial wait
			time.Sleep(time.Millisecond*200)
			for i:=0; i<M; i++ {
				// create message with message id, time 
				msg := message{}
				msg.id = i
				msg.trace = []byte(">")
				// get a permutation of other addresses and pick first K
				perm := rand.Perm(N-1)
				for i:=0; i<K; i++ {
					msg.time = []byte(time.Now().Format(TF))
					send(remoteAddr[perm[i]],msg)
					// pause
					time.Sleep(time.Millisecond*100)
				}
			}
			fmt.Println("🛑 Agent",id,"stopping 🛑")
			fmt.Println()
			os.Exit(0)
		}()
	}
	// create channel for receiving messages
	ch := make(chan message)
	// start listening
	go receive(baseAddr,basePort,ch)
	fmt.Println("  📪 Other ports:",otherPorts)
	// gossip M times
	for rid<M || !sent {
		// get a new message
		msg := <-ch
		// get permutation pick first K non-sender messages
		perm := rand.Perm(N-1)
		k:=0
		for j:=0; j<N-1 && k<K; j++ {
			if otherPorts[perm[j]]!=msg.from {
				send(remoteAddr[perm[j]],msg)
				k++
			}
		}
	}
	// end
	fmt.Println("🛑 Agent",id,"stopping 🛑")
	fmt.Println()
	os.Exit(0)
}