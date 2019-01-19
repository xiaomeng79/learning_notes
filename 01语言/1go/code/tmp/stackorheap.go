package main

func main() {
	a := make([]int,0,20)

	b := make([]int,0,20000)

	l := 20

	c := make([]int,0,l)
}

//查看编译申请空间 go build -gcflags='-m' . 2>&1
func f() {
	a := make([]int,0,20)

	b := make([]int,0,20000)

	l := 20

	c := make([]int,0,l)
}
