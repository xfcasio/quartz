const std = @import("std");
const posix = std.posix;
const log = std.log.scoped(.net);

pub fn command(_: [][*:0]u8) void {
    dispatch_timer_daemon_with_cmd(0, "notify-send hello") catch unreachable;
}

fn dispatch_timer_daemon_with_cmd(exec_in_mins: usize, cmd: [:0]const u8) !void {
    _ = .{ exec_in_mins, cmd };
    try daemonize();

    // HERE
    posix.execveZ("/bin/sh", &.{"sh", "-c", cmd}, std.c.environ) catch unreachable;

    unreachable;
}

fn daemonize() !void {
    if (try posix.fork() > 0) return;

    _ = posix.setsid() catch |err| {
        log.err("setsid failed: {s}", .{ @errorName(err) });
        posix.exit(1);
    };

    if (try posix.fork() > 0) posix.exit(0);

    try redirect_stdio_to_devnull();
}

fn redirect_stdio_to_devnull() !void {
    const devnull = (
        try std.fs.openFileAbsolute("/dev/null", .{ .mode = .read_write })
    ).handle;
    defer posix.close(devnull);

    try posix.dup2(devnull, 0);
    try posix.dup2(devnull, 1);
    try posix.dup2(devnull, 2);
}
