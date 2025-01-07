const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("spinlock", .{
        .root_source_file = b.path("spinlock.zig"),
    });
}
