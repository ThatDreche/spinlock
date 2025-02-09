# spinlock
A simple spinlock in zig, with the same API as [std.Thread.Mutex](https://ziglang.org/documentation/master/std/#std.Thread.Mutex).
Use this only if you NEED a spinlock, use a proper mutex with OS blessings otherwise.

## Usage
First, add the package to your build.zig.zon:
`zig fetch --save=spinlock https://github.com/ThatDreche/spinlock/archive/v1.0.0.tar.gz`
Then, add the following to your build.zig:
```zig
const spinlock = b.dependency("spinlock", .{
    .target = target,
    .optimize = optimize,
});
exe.root_module.addImport("spinlock", spinlock.module("spinlock"));
```
