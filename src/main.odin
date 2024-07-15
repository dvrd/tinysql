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

		if ib.buf[0] == '.' {
			switch do_meta_command(ib) {
			case .SUCCESS:
				continue program
			case .UNRECOGNIZED_COMMAND:
				log.errorf("Unrecognized command '%s'", to_string(ib))
				continue program
			}
		}

		stmt: Statement
		switch prepare_statement(ib, &stmt) {
		case .SUCCESS:
		case .UNRECOGNIZED_STATEMENT:
			log.errorf("Unrecognized keyword at start of '%s'.", to_string(ib))
			continue program
		}

		execute_statement(&stmt)
		log.debug("Executed.")
	}
}

to_string_with_len :: proc(ib: ^Input_Buffer) -> string {
	return cast(string)ib.buf[:ib.len]
}

to_string_with_pos :: proc(ib: ^Input_Buffer, pos: int) -> string {
	return cast(string)ib.buf[:pos]
}

to_string :: proc{to_string_with_len, to_string_with_pos}

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
