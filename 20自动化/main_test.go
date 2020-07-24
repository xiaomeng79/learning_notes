package main

import "testing"

func TestSum(t *testing.T) {
	a, b, sum := 1, 2, 3
	if sum != Sum(a, b) {
		t.Error("sum is error")
	}
}
