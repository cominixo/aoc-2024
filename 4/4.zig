const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

const input = @embedFile("input");
const print = std.debug.print;
const search_string = "XMAS";

pub fn searchArray(arr: std.ArrayList(std.ArrayList(u8)), str_index: usize, x: usize, y: usize, x_dir: i32, y_dir: i32) u32 {
    var found: u32 = 0;
    
    if (arr.items[y].items[x] == search_string[str_index]) {
        if (str_index == search_string.len-1) return 1;

        if ((x == 0 and x_dir == -1) or (y == 0 and y_dir == -1) or 
            (x == arr.items[y].items.len-1 and x_dir == 1) or (y == arr.items.len-1 and y_dir == 1)) {
            return 0;
        }

        const new_x: u64 = @intCast(@as(i32,@intCast(x)) + x_dir);
        const new_y: u64 = @intCast(@as(i32,@intCast(y)) + y_dir);

        found += searchArray(arr, str_index+1, new_x, new_y, x_dir, y_dir);
    }
    
    return found;
}

pub fn part1(arr: std.ArrayList(std.ArrayList(u8))) void {
    var total: u32 = 0;
    for (0..arr.items.len) |y| {
        for (0..arr.items[y].items.len) |x| {
            for (0..3) |y_dir| {
                for (0..3) |x_dir| {
                    if (y_dir == 1 and x_dir == 1) continue;

                    const y_dir_sign: i64 = @bitCast(y_dir);
                    const x_dir_sign: i64 = @bitCast(x_dir);

                    total += searchArray(arr,  0, x, y, @truncate(x_dir_sign-1), @truncate(y_dir_sign-1));
                }
            }
        }
    }

    print("{}\n", .{total});
}

pub fn part2(arr: std.ArrayList(std.ArrayList(u8))) void {
    var total: u32 = 0;
    for (0..arr.items.len) |y| {
        for (0..arr.items[y].items.len) |x| {
            if (arr.items[y].items[x] == 'A') {
                if (x == 0 or y == 0 or 
                    x == arr.items[y].items.len-1 or y == arr.items.len-1) {
                    continue;
                }

                if ((arr.items[y-1].items[x-1] == 'M' or arr.items[y+1].items[x+1] == 'M') and 
                    (arr.items[y-1].items[x-1] == 'S' or arr.items[y+1].items[x+1] == 'S') and 
                    (arr.items[y+1].items[x-1] == 'M' or arr.items[y-1].items[x+1] == 'M') and 
                    (arr.items[y+1].items[x-1] == 'S' or arr.items[y-1].items[x+1] == 'S')) {
                        total += 1;        
                }
            }
        }
    }

    print("{}\n", .{total});
}


pub fn main() !void {
    var it = std.mem.tokenizeScalar(u8, input, '\n');

    var arr: std.ArrayList(std.ArrayList(u8)) = .init(allocator);

    while (it.next()) |line| {

        var line_arr: std.ArrayList(u8) = .init(allocator);

        for (line) |char| {
            try line_arr.append(char);
        }

        try arr.append(line_arr);
    }

    part1(arr);
    part2(arr);

}