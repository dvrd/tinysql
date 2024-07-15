package tinysql

import "core:fmt"
import "core:log"
import "core:os"
import "core:slice"

Input_Buffer :: struct {
	buf: [4096]byte,
	len: int,
}

main :: proc() {
	context.logger = log.create_console_logger(opt = log.Options{.Level, .Terminal_Color})
	ib := new(Input_Buffer)
	program: for true {
		fmt.print("db > ")
		ok := read_input(ib)
		if (!ok) {
			log.error("Error reading input")
			os.exit(1)
		}

		if to_string(ib) == ".exit" {
			break program
		} else {
			log.errorf("Unrecognized command '%s'.", to_string(ib))
		}
	}
}

to_string :: proc(ib: ^Input_Buffer) -> string {
	return cast(string)ib.buf[:ib.len]
}

read_input :: proc(ib: ^Input_Buffer) -> bool {
	errno: os.Errno
	for !slice.contains(ib.buf[:], '\n') {
		ib.len, errno = os.read(os.stdin, ib.buf[:])
		if errno != os.ERROR_NONE do return false
	}
	ib.len -= 1
	ib.buf[ib.len] = 0 // removes trailing newline
	return ib.len > 0
}
