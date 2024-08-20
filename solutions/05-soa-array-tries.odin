package solutions

import "core:fmt"
import "core:os"
import "core:strings"

SOA_Array_Trie :: struct {
    nodes:  #soa[MAX_TRIE_NODES]SOA_Array_Trie_Node,
    length: int,
}

SOA_Array_Trie_Node :: struct {
    children: [26]int,
    // is_leaf:  bool,
    n:        int,
}

soa_array_trie_make :: proc() -> (soa_array_trie: ^SOA_Array_Trie) {
    soa_array_trie = new(SOA_Array_Trie)
    soa_array_trie_reset(soa_array_trie)
    return
}

soa_array_trie_delete :: proc(soa_array_trie: ^SOA_Array_Trie) {
    free(soa_array_trie)
}

soa_array_trie_reset :: proc(soa_array_trie: ^SOA_Array_Trie) {
    for soa_array_index in 0 ..< MAX_TRIE_NODES {
        for child_index in 0 ..< 26 {
            soa_array_trie.nodes[soa_array_index].children[child_index] = -1
        }
    }
    soa_array_trie.length = 1
}

soa_array_trie_insert :: proc(soa_array_trie: ^SOA_Array_Trie, word: string) {
    current_node := &soa_array_trie.nodes[0]

    for char in word {
        index := char_to_index(char)
        trie_index: int

        if current_node.children[index] >= 0 {
            trie_index = current_node.children[index]
        } else {
            child_index := soa_array_trie.length
            current_node.children[index] = child_index

            soa_array_trie.length += 1

            trie_index = child_index
        }

        current_node = &soa_array_trie.nodes[trie_index]
    }
    current_node.n += 1
    // current_node.is_leaf = true
}

soa_array_trie_get_words :: proc(soa_array_trie: ^SOA_Array_Trie, acc: ^[dynamic]Entry) {
    dfs :: proc(soa_array_trie: ^SOA_Array_Trie, index: int, buffer: string, acc: ^[dynamic]Entry) {
        if index < 0 || index >= MAX_TRIE_NODES {return}

        node := soa_array_trie.nodes[index]
        // if node.is_leaf {
        if node.n > 0 {
            append_elem(acc, Entry{buffer, node.n})
        }
        for child, index in node.children {
            if child < 0 {continue}
            dfs(soa_array_trie, child, fmt.aprintf("%s%v", buffer, index_to_char(index)), acc)
        }
    }

    dfs(soa_array_trie, 0, "", acc)
}

solution_5 :: proc(source: Sanitized_Input, soa_array_trie: ^SOA_Array_Trie) -> bool {
    for word in source {
        soa_array_trie_insert(soa_array_trie, word)
    }

    return true
}

solution_5_write_to_file :: proc(source: Sanitized_Input, filepath: string) {
    soa_array_trie := soa_array_trie_make()
    defer free(soa_array_trie)

    for word in source {
        soa_array_trie_insert(soa_array_trie, word)
    }

    acc := make([dynamic]Entry)
    soa_array_trie_get_words(soa_array_trie, &acc)

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
        fmt.printf("Successfully written solution 5 to %s\n", filepath)
    } else {
        fmt.eprintf("ERROR: Failed to write solution 5 to %s\n", filepath)
    }
}
