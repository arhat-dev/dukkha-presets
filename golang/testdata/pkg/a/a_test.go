package a

import (
	"testing"
)

func Test(t *testing.T) {
	if A() != "A" {
		t.Fail()
	}
}
