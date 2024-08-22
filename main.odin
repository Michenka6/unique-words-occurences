package main

import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"
import "core:time"
import "solutions"

Solution_Number :: enum {
    First,
    Second,
    Third,
    Fourth,
    Fifth,
}

main :: proc() {
    filepath := os.args[1]
    source, ok := os.read_entire_file_from_filename(filepath)
    if !ok {fmt.eprintln("ERROR: Failed to the read the input file")}

    input := make([dynamic]string)
    solutions.sanitize_input(string(source), &input)

    // run_solution(&input, .First)
    run_solution(&input, .Second)
    run_solution(&input, .Third)
    run_solution(&input, .Fourth)
    run_solution(&input, .Fifth)
}

NUMBER_OF_RUNS :: 1

RED :: "\e[31m"
NC :: "\e[0m"

run_solution :: proc(source: solutions.Sanitized_Input, sn: Solution_Number) {
    // when ODIN_DEBUG {
    //     track: mem.Tracking_Allocator
    //     memory_allocated: i64 = 0
    //     mem.tracking_allocator_init(&track, context.allocator)
    //     context.allocator = mem.tracking_allocator(&track)
    //
    //     defer {
    //         if len(track.allocation_map) > 0 {
    //             fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
    //             for _, entry in track.allocation_map {
    //                 // fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
    //             }
    //         }
    //         if len(track.bad_free_array) > 0 {
    //             fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
    //             for entry in track.bad_free_array {
    //                 fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
    //             }
    //         }
    //         fmt.printf("Memory allocated on average: %i MB\n", memory_allocated / 1024 / 1024 / NUMBER_OF_RUNS)
    //         mem.tracking_allocator_destroy(&track)
    //     }
    // }
    total := 0.0
    // Solution 4/5 preload
    array_trie := solutions.array_trie_make()
    soa_array_trie := solutions.soa_array_trie_make()
    // ############################
    for _ in 0 ..< NUMBER_OF_RUNS {
        start := time.now()

        res: bool
        switch sn {
        case .First:
            res = solutions.solution_1(source)
        case .Second:
            res = solutions.solution_2(source)
        case .Third:
            res = solutions.solution_3(source)
        case .Fourth:
            res = solutions.solution_4(source, array_trie)
        case .Fifth:
            res = solutions.solution_5(source, soa_array_trie)
        }


        end := time.now()
        duration := time.diff(start, end)
        milsec_elapsed := time.duration_milliseconds(duration)
        total += milsec_elapsed
        // Solution 4/5 reset
        solutions.array_trie_reset(array_trie)
        solutions.soa_array_trie_reset(soa_array_trie)
        // ###################################
        // when ODIN_DEBUG {
        //     memory_allocated += track.total_memory_allocated
        //     mem.tracking_allocator_reset(&track)
        // }
    }
    solutions.array_trie_delete(array_trie)
    solutions.soa_array_trie_delete(soa_array_trie)
    total /= NUMBER_OF_RUNS

    fmt.print('\t')
    switch sn {
    case .First:
        fmt.printf("Dynamic Array  - average time(ms): %s%v%s\n", RED, total, NC)
    case .Second:
        fmt.printf("In-built map   - average time(ms): %s%v%s\n", RED, total, NC)
    case .Third:
        fmt.printf("Naive trie     - average time(ms): %s%v%s\n", RED, total, NC)
    case .Fourth:
        fmt.printf("Array trie     - average time(ms): %s%v%s\n", RED, total, NC)
    case .Fifth:
        fmt.printf("SOA-Array trie - average time(ms): %s%v%s\n", RED, total, NC)
    }

    fmt.print('\t')
    switch sn {
    case .First:
        solutions.solution_1_write_to_file(source, "occurence-tables/solution-1.json")
    case .Second:
        solutions.solution_2_write_to_file(source, "occurence-tables/solution-2.json")
    case .Third:
        solutions.solution_3_write_to_file(source, "occurence-tables/solution-3.json")
    case .Fourth:
        solutions.solution_4_write_to_file(source, "occurence-tables/solution-4.json")
    case .Fifth:
        solutions.solution_5_write_to_file(source, "occurence-tables/solution-5.json")
    }
    fmt.println()
}
