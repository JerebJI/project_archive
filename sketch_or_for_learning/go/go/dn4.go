package main

import (
	"flag"
	"errors"
	"sync"
	"fmt"
	"net/rpc"
	"net"
	"time"
)

var N int
var id int

func checkError(err error) {
	if err != nil {
		panic(err)
	}
}

var putLock sync.Mutex
var previous, next *rpc.Client
var basePort int
var store *TodoStorage
var TF = "15:04:05.9999" // time format

func main() {
	// read arguments
	portPtr := flag.Int("p", 9000, "# start port")
	idPtr := flag.Int("id", 0, "# process id")
	NPtr := flag.Int("n", 2, "total number of processes")
	flag.Parse()
	rootPort := *portPtr
	id = *idPtr
	N = *NPtr
	// initialize basePort
	basePort = rootPort+1+id
	baseAddr, err := net.ResolveTCPAddr("tcp",fmt.Sprintf("localhost:%d",basePort))
	checkError(err)
	// initialize storage
	store = NewTodoStorage()
	rpc.Register(store)
	// initialize serving
	l, err := net.ListenTCP("tcp",baseAddr)
	checkError(err)
	time.Sleep(time.Second)
	if id>0 {
		previous, err = rpc.Dial("tcp",fmt.Sprintf("localhost:%d",basePort-1))
		checkError(err)
	}
	if id<N-1 {
		next, err = rpc.Dial("tcp",fmt.Sprintf("localhost:%d",basePort+1))
		checkError(err)
	}
	fmt.Println("")
	fmt.Println("🏁 Agent",id,"initialized. 🏁")
	go rpc.Accept(l)
	if id>0 && id<N-1 {
		prv,_ := net.ResolveTCPAddr("tcp",fmt.Sprintf("localhost:%d",basePort-1))
		nxt,_ := net.ResolveTCPAddr("tcp",fmt.Sprintf("localhost:%d",basePort+1))
		fmt.Println(prv,"<--","Agent",id,"on",baseAddr,"-->",nxt)
	}
	if id==0 {
		nxt,_ := net.ResolveTCPAddr("tcp",fmt.Sprintf("localhost:%d",basePort+1))
		fmt.Println("Agent",id,"on",baseAddr,"-->",nxt)
	}
	if id==N-1 {
		prv,_ := net.ResolveTCPAddr("tcp",fmt.Sprintf("localhost:%d",basePort-1))
		fmt.Println(prv,"<--","Agent",id,"on",baseAddr)
	}
	time.Sleep(3*time.Second)
	fmt.Println("🛑 END 🛑")
}

type Todo struct {
	Task      string `json:"task"`
	Completed bool   `json:"completed"`
	Commited  bool   `json:"commited"`
}

type TodoStorage struct {
	dict map[string]Todo
	// ključavnica za bralne in pisalne dostope do shrambe
	mu sync.RWMutex
}

var ErrorNotFound = errors.New("not found")

func NewTodoStorage() *TodoStorage {
	dict := make(map[string]Todo)
	return &TodoStorage{
		dict: dict,
	}
}

func (tds *TodoStorage) Get(todo *Todo, dict *map[string]Todo) error {
	fmt.Println("📨",time.Now().Format(TF),"get",*todo)
	tds.mu.RLock()
	defer tds.mu.RUnlock()
	if todo.Task == "" {
		for k, v := range tds.dict {
			(*dict)[k] = v
		}
		return nil
	} else {
		if val, ok := tds.dict[todo.Task]; ok && val.Commited {
			(*dict)[val.Task] = val
			fmt.Println("📨 sent 📨")
			return nil
		}
		return ErrorNotFound
	}
}

func (tds *TodoStorage) Put(todo *Todo, ret *struct{}) error {
	putLock.Lock()
	defer putLock.Unlock()
	fmt.Println("💾",time.Now().Format(TF),"put:",*todo)
	tds.mu.Lock()
	todo.Commited = false
	tds.dict[todo.Task] = *todo
	tds.mu.Unlock()
	var reply struct{}
	if id!=N-1 {
		next.Call("TodoStorage.Put",todo,&reply)
	} else {
		store.Commit(todo,&reply)
	}
	return nil
}

func (tds *TodoStorage) Commit(todo *Todo, ret *struct{}) error {
	fmt.Println("✅",time.Now().Format(TF),"commit:",*todo)
	tds.mu.Lock()
	defer tds.mu.Unlock()
	if t, ok := tds.dict[todo.Task]; ok {
		t.Commited = true
		tds.dict[todo.Task] = t
		if id!=0 {
			var reply struct{}
			previous.Call("TodoStorage.Commit",todo,&reply)
		}
		return nil
	}
	return ErrorNotFound
}
