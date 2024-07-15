package tinysql

import "core:os"

MetaCommandResult :: enum {
	SUCCESS,
	UNRECOGNIZED_COMMAND,
}

do_meta_command :: proc(ib: ^Input_Buffer) -> MetaCommandResult {
	if to_string(ib) == ".exit" {
		os.exit(0)
	}

	return .UNRECOGNIZED_COMMAND
}
