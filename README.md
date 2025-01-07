# spinlock
A simple spinlock in zig, with the same API as [std.Thread.Mutex](https://ziglang.org/documentation/master/std/#std.Thread.Mutex).  
Use this only if you NEED a spinlock, use a proper mutex with OS blessings otherwise.
