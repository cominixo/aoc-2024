const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

const input = @embedFile("input");
const print = std.debug.print;

pub fn solve(comptime part2: bool, levels: std.ArrayList(std.ArrayList(i32))) !void {
    var total: u32 = 0;
    for (levels.items) |level| {
        // for part 2, bruteforce all possible combinations of removed items from the list
        const num_iterations = if (part2) level.items.len else 1;
        for (0..num_iterations) |i| {
            var actual_level: std.ArrayList(i32) = undefined;
            if (part2) {
                actual_level = .init(allocator);
                for (0..level.items.len) |j| {
                    if (i!=j) try actual_level.append(level.items[j]);
                }
            } else {
                actual_level = level;
            }

            var it = std.mem.window(i32, actual_level.items, 2, 1);
            const first = it.next().?;
            const last_diff = first[0] - first[1];
            var safe: bool = true;

            if (@abs(last_diff) > 3) {
                safe = false;
            } else {
                while (it.next()) |slice| {
                    const diff = slice[0] - slice[1];
                    if (diff * last_diff <= 0 or @abs(diff) > 3) {
                        safe = false;
                    }
                }
            }

            if (safe) {
                total += 1;
                break;
            }

        }
        
    }
    print("{}\n", .{total});
}


pub fn main() !void {
    var it = std.mem.tokenizeScalar(u8, input, '\n');

    var levels: std.ArrayList(std.ArrayList(i32)) = .init(allocator);

    while (it.next()) |line| {
        var level: std.ArrayList(i32) = .init(allocator);
        var line_it = std.mem.tokenizeScalar(u8, line, ' ');
        while (line_it.next()) |value| {
            try level.append(try std.fmt.parseInt(i32, value, 10));
        }
        try levels.append(level);
    }

    try solve(false, levels);
    try solve(true, levels);
}