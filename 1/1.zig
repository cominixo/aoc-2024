const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

const input = @embedFile("input");
const print = std.debug.print;

pub fn part1(slice1: []i32, slice2: []i32) void {
    std.mem.sort(i32, slice1, {}, std.sort.asc(i32));
    std.mem.sort(i32, slice2, {}, std.sort.asc(i32));

    var total: u32 = 0;

    for (0..slice1.len) |i| {
        total += @abs(slice1[i]-slice2[i]);
    }

    print("{}\n", .{total});
}

pub fn part2(slice1: []i32, slice2: []i32) void {
    var total: i32 = 0;
    for (slice1) |left| {
        for (slice2) |right| {
            if (left == right) total += left;
        }
    }
    print("{}\n", .{total});
}


pub fn main() !void {
    var it = std.mem.tokenizeScalar(u8, input, '\n');

    var arr1: std.ArrayList(i32) = .init(allocator);
    var arr2: std.ArrayList(i32) = .init(allocator);

    while (it.next()) |line| {
        var it2 = std.mem.tokenizeScalar(u8, line, ' ');
        try arr1.append(try std.fmt.parseInt(i32, it2.next().?, 10));
        try arr2.append(try std.fmt.parseInt(i32, it2.next().?, 10));
    }

    const slice1 = try arr1.toOwnedSlice();
    const slice2 = try arr2.toOwnedSlice();

    part1(slice1, slice2);
    part2(slice1, slice2);
}