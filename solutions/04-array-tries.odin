package solutions

import "core:fmt"
import "core:os"
import "core:strings"

Array_Trie :: struct {
    nodes:  [MAX_TRIE_NODES]Array_Trie_Node,
    length: int,
}

Array_Trie_Node :: struct {
    children: [26]int,
    // is_leaf:  bool,
    n:        int,
}

array_trie_make :: proc() -> (array_trie: ^Array_Trie) {
    array_trie = new(Array_Trie)
    array_trie_reset(array_trie)
    return
}

array_trie_delete :: proc(array_trie: ^Array_Trie) {
    free(array_trie)
}

array_trie_reset :: proc(array_trie: ^Array_Trie) {
    for array_index in 0 ..< MAX_TRIE_NODES {
        for child_index in 0 ..< 26 {
            array_trie.nodes[array_index].children[child_index] = -1
        }
    }
    array_trie.length = 1
}

array_trie_insert :: proc(array_trie: ^Array_Trie, word: string) {
    current_node := &array_trie.nodes[0]

    for char in word {
        index := char_to_index(char)
        trie_index: int

        if current_node.children[index] >= 0 {
            trie_index = current_node.children[index]
        } else {
            child_index := array_trie.length
            current_node.children[index] = child_index

            array_trie.length += 1

            trie_index = child_index
        }

        current_node = &array_trie.nodes[trie_index]
    }
    current_node.n += 1
    // current_node.is_leaf = true
}

array_trie_get_words :: proc(array_trie: ^Array_Trie, acc: ^[dynamic]Entry) {
    dfs :: proc(array_trie: ^Array_Trie, index: int, buffer: string, acc: ^[dynamic]Entry) {
        if index < 0 || index >= MAX_TRIE_NODES {return}

        node := array_trie.nodes[index]
        // if node.is_leaf {
        if node.n > 0 {
            append_elem(acc, Entry{buffer, node.n})
        }
        for child, index in node.children {
            if child < 0 {continue}
            dfs(array_trie, child, fmt.aprintf("%s%v", buffer, index_to_char(index)), acc)
        }
    }

    dfs(array_trie, 0, "", acc)
}

solution_4 :: proc(source: Sanitized_Input, array_trie: ^Array_Trie) -> bool {
    for word in source {
        array_trie_insert(array_trie, word)
    }

    return true
}

solution_4_write_to_file :: proc(source: Sanitized_Input, filepath: string) {
    array_trie := array_trie_make()
    defer free(array_trie)

    for word in source {
        array_trie_insert(array_trie, word)
    }

    acc := make([dynamic]Entry)
    array_trie_get_words(array_trie, &acc)

    sb := strings.builder_make()
    defer strings.builder_destroy(&sb)

    strings.write_byte(&sb, '{')
    strings.write_byte(&sb, '\n')

    flag := false
    for entry in acc {
        if flag {strings.write_byte(&sb, ',')}
        write_string_int_pair(&sb, entry.word, entry.count)
        flag = true
    }

    strings.write_byte(&sb, '\n')
    strings.write_byte(&sb, '}')

    if os.write_entire_file(filepath, sb.buf[:]) {
        fmt.printf("Successfully written solution 4 to %s\n", filepath)
    } else {
        fmt.eprintf("ERROR: Failed to write solution 4 to %s\n", filepath)
    }
}
