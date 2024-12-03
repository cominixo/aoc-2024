const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

const input = @embedFile("input");
const print = std.debug.print;

pub fn main() !void {
    var start: usize = 0;

    var total_part1: u32 = 0;
    var total_part2: u32 = 0;

    var should_mul: bool = true;

    while (true) {
        const index = std.mem.indexOf(u8, input[start..], "mul");

        const mul_toggle_index = if (should_mul) std.mem.indexOf(u8, input[start..], "don't()") 
                                 else std.mem.indexOf(u8, input[start..], "do()");

        if (index == null) break;

        start += index.? + 3;

        if (mul_toggle_index != null) {
            if (mul_toggle_index.? < index.?) {
                should_mul = !should_mul;
            }
        }

        if (input[start] == '(') {
            const closing_bracket_ind = std.mem.indexOfScalar(u8, input[start..], ')').?;
            var it = std.mem.splitScalar(u8, input[start+1..start+closing_bracket_ind], ',');
            const val1 = std.fmt.parseInt(u32, it.next().?, 10) catch {continue;};
            const next = it.next();
            if (next == null) continue;
            const val2 = std.fmt.parseInt(u32, next.?, 10) catch {continue;};
            if (it.next() != null) continue;
            if (val1 / 1000 == 0 and val2 / 1000 == 0) {
                if (should_mul) total_part2 += val1 * val2;
                total_part1 += val1*val2;
            }

        }
    }
    
    print("{}\n{}\n", .{total_part1, total_part2});

}