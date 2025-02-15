const std = @import("std");

pub const Spinlock = struct {
    const Self = @This();
    const State = enum(u8) { Unlocked = 0, Locked };
    const AtomicState = std.atomic.Value(State);

    value: AtomicState = AtomicState.init(.Unlocked),

    pub fn lock(self: *Self) void {
        while (!self.tryLock()) {
            std.atomic.spinLoopHint();
        }
    }

    pub fn tryLock(self: *Self) bool {
        return switch (self.value.swap(.Locked, .acquire)) {
            .Locked => false,
            .Unlocked => true,
        };
    }

    pub fn unlock(self: *Self) void {
        self.value.store(.Unlocked, .release);
    }
};

test "basics" {
    var lock = Spinlock{};

    lock.lock();
    try std.testing.expect(!lock.tryLock());
    lock.unlock();

    try std.testing.expect(lock.tryLock());
    try std.testing.expect(!lock.tryLock());
    lock.unlock();
}
