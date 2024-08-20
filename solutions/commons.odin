package solutions

import "core:fmt"
import "core:strings"
import "core:unicode"

MAX_TRIE_NODES :: 1_000

Sanitized_Input :: #type ^[dynamic]string

to_valid :: proc(x: rune) -> (y: rune) {
    switch x {
    case 'a' ..= 'z':
        return x
    case 'A' ..= 'Z':
        return rune(u8(x) + 32)
    }
    return ' '
}

sanitize_input :: proc(source: string, s: Sanitized_Input) {
    sb := strings.builder_make()
    // defer strings.builder_destroy(&sb)

    for char in source {
        strings.write_byte(&sb, u8(to_valid(char)))
    }

    b := strings.to_string(sb)
    for word in strings.split_iterator(&b, " ") {
        if word == "" {continue}
        append_elem(s, word)
    }
}


char_to_index :: proc(char: rune) -> (index: int) {
    index = int(char)
    index -= 97
    return
}

index_to_char :: proc(index: int) -> (char: rune) {
    char = rune(index + 97)
    return
}

write_string_int_pair :: proc(sb: ^strings.Builder, key: string, value: int) {
    strings.write_byte(sb, '\n')

    strings.write_byte(sb, '\"')
    strings.write_bytes(sb, transmute([]u8)key)
    strings.write_byte(sb, '\"')

    strings.write_byte(sb, ' ')
    strings.write_byte(sb, ':')
    strings.write_byte(sb, ' ')

    strings.write_int(sb, value)
}
