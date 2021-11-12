package b

import (
	"testing"
)

func Test(t *testing.T) {
	if B() == "A" {
		t.Fail()
	}
}
