package tinysql

import "core:log"
PrepareResult :: enum {
	SUCCESS,
	UNRECOGNIZED_STATEMENT,
}

Statement_Type :: enum {
	INSERT,
	SELECT,
}

Statement :: struct {
	type: Statement_Type,
}

prepare_statement :: proc(ib: ^Input_Buffer, stmt: ^Statement) -> PrepareResult {
  if to_string(ib, 6) == "insert" {
    stmt.type = .INSERT;
    return .SUCCESS;
  }
  if to_string(ib) == "select" {
    stmt.type = .SELECT;
    return .SUCCESS;
  }

  return .UNRECOGNIZED_STATEMENT;
}

execute_statement :: proc(stmt: ^Statement) {
  switch stmt.type {
    case .INSERT:
      log.debug("This is where we would do an insert.");
      break;
    case .SELECT:
      log.debug("This is where we would do a select.");
      break;
  }
}
