package solutions

import "core:fmt"
import "core:os"
import "core:strings"

solution_2 :: proc(source: Sanitized_Input) -> bool {
    word_map := make(map[string]int)
    defer delete(word_map)

    for word in source {
        n := word_map[word]
        word_map[word] = n + 1
    }

    return true
}

solution_2_write_to_file :: proc(source: Sanitized_Input, filepath: string) {
    word_map := make(map[string]int)
    defer delete(word_map)

    for word in source {
        n := word_map[word]
        word_map[word] = n + 1
    }

    sb := strings.builder_make()
    defer strings.builder_destroy(&sb)

    strings.write_byte(&sb, '{')
    strings.write_byte(&sb, '\n')

    flag := false
    for k, v in word_map {
        if flag {strings.write_byte(&sb, ',')}
        write_string_int_pair(&sb, k, v)
        flag = true
    }

    strings.write_byte(&sb, '\n')
    strings.write_byte(&sb, '}')

    if os.write_entire_file(filepath, sb.buf[:]) {
        fmt.printf("Successfully written solution 2 to %s\n", filepath)
    } else {
        fmt.eprintf("ERROR: Failed to write solution 2 to %s\n", filepath)
    }
}
