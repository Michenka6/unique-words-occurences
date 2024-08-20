package solutions

import "core:fmt"
import "core:os"
import "core:strings"


Naive_Trie :: struct {
    children: [26]^Naive_Trie,
    // is_leaf:  bool,
    n:        int,
}

naive_trie_make :: proc() -> (root: ^Naive_Trie) {
    root = new(Naive_Trie)
    node := Naive_Trie{}
    root^ = node
    return
}

naive_trie_insert :: proc(root: ^Naive_Trie, word: string) {
    current_node := root

    for char in word {
        index := char_to_index(char)

        if current_node.children[index] == nil {
            current_node.children[index] = naive_trie_make()
        }
        current_node = current_node.children[index]
    }
    current_node.n += 1
    // current_node.is_leaf = true
}

naive_trie_delete :: proc(node: ^Naive_Trie) {
    if node == nil {return}
    for child in node.children {
        naive_trie_delete(child)
    }
    free(node)
}

naive_trie_get_words :: proc(node: ^Naive_Trie, acc: ^[dynamic]Entry) {
    dfs :: proc(node: ^Naive_Trie, buffer: string, acc: ^[dynamic]Entry) {
        if node == nil {return}
        // if node.is_leaf {
        if node.n > 0 {
            append_elem(acc, Entry{buffer, node.n})
        }
        for child, index in node.children {
            dfs(child, fmt.aprintf("%s%v", buffer, index_to_char(index)), acc)
        }
    }

    dfs(node, "", acc)
}

solution_3 :: proc(source: Sanitized_Input) -> bool {
    root := naive_trie_make()
    defer naive_trie_delete(root)

    for word in source {
        naive_trie_insert(root, word)
    }
    return true
}

solution_3_write_to_file :: proc(source: Sanitized_Input, filepath: string) {
    root := naive_trie_make()
    defer naive_trie_delete(root)

    for word in source {
        naive_trie_insert(root, word)
    }

    acc := make([dynamic]Entry)
    naive_trie_get_words(root, &acc)

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
        fmt.printf("Successfully written solution 3 to %s\n", filepath)
    } else {
        fmt.eprintf("ERROR: Failed to write solution 3 to %s\n", filepath)
    }
}
