package main

import "fmt"

type Int int
type V interface {
	Iter() <-chan Int
}

func (t *Int) Get() V {
	iter := func() <-chan Int {
		ch := make(chan Int)
		go func() {
			for i:=0; i< 5 ; i++  {
				ch<-Int(i)
			}
			close(ch)
		}()
		return ch
	}
	return V(&Vhelp{iterFunc:iter})
}

type Vhelp struct {
	iterFunc func() <-chan Int
}

func (v *Vhelp) Iter() <-chan Int {
	return v.iterFunc()
}

func main() {
	t := new(Int)
	ss := t.Get().Iter()
	for s := range ss {
		fmt.Println(s)
	}


}