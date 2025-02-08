const std = @import("std");
const testing = std.testing;
const builtin = @import("builtin");
const Thread = std.Thread;

pub const Spinlock = struct {
    const Self = @This();
    const State = enum(u8) { Unlocked = 0, Locked };
    const AtomicState = std.atomic.Value(State);

    value: AtomicState = AtomicState.init(.Unlocked),

    pub fn lock(self: *Self) void {
        while (true) {
            switch (self.value.swap(.Locked, .acquire)) {
                .Locked => std.atomic.spinLoopHint(),
                .Unlocked => break,
            }
        }
    }

    pub fn tryLock(self: *Self) bool {
        return switch (self.value.swap(.Locked, .acquire)) {
            .Locked => return false,
            .Unlocked => return true,
        };
    }

    pub fn unlock(self: *Self) void {
        self.value.store(.Unlocked, .release);
    }
};

test "basics" {
    var lock = Spinlock{};

    lock.lock();
    try testing.expect(!lock.tryLock());
    lock.unlock();

    try testing.expect(lock.tryLock());
    try testing.expect(!lock.tryLock());
    lock.unlock();
}
