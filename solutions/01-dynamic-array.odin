package solutions

import "core:fmt"
import "core:os"
import "core:strings"

Entry :: struct {
    word:  string,
    count: int,
}

Entry_Map :: [dynamic]Entry

add_word :: proc(s: string, word_map: ^Entry_Map) {
    for &w in word_map {
        if s == w.word {w.count += 1;return}
    }

    new_entry := Entry{s, 1}
    append_elem(word_map, new_entry)
}

solution_1 :: proc(source: Sanitized_Input) -> bool {
    word_map: Entry_Map = make(Entry_Map)
    defer delete(word_map)

    for word in source {
        add_word(word, &word_map)
    }
    return true
}

solution_1_write_to_file :: proc(source: Sanitized_Input, filepath: string) {
    word_map: Entry_Map = make(Entry_Map)
    defer delete(word_map)
    for word in source {
        add_word(word, &word_map)
    }

    sb := strings.builder_make()
    defer strings.builder_destroy(&sb)

    strings.write_byte(&sb, '{')
    strings.write_byte(&sb, '\n')

    flag := false
    for entry in word_map {
        if flag {strings.write_byte(&sb, ',')}
        write_string_int_pair(&sb, entry.word, entry.count)
        flag = true
    }

    strings.write_byte(&sb, '\n')
    strings.write_byte(&sb, '}')

    if os.write_entire_file(filepath, sb.buf[:]) {
        fmt.printf("Successfully written solution 1 to %s\n", filepath)
    } else {
        fmt.eprintf("ERROR: Failed to write solution 1 to %s\n", filepath)
    }
}
