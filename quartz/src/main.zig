const std = @import("std");
const Io = std.Io;
const mem = std.mem;
const meta = std.meta;
const log = std.log;
const posix = std.posix;
const fs = std.fs;
const assert = std.debug.assert;

const Commands = enum { net, habit, feynman, search, fetch, mismatch };
const commands: std.StaticStringMap(Commands) = .initComptime(.{
    .{ "net", .net },
    .{ "habit", .habit },
    .{ "feynman", .feynman },
    .{ "search", .search },
    .{ "fetch", .fetch },
});

fn usage() noreturn {
    log.err(
        \\invalid command.
        \\usage: quartz [command] [options]
        \\
        \\Commands:
        \\  net      -   Internet access control
        \\  search   -   Semantic search engine over local knowledge base
        \\  feynman  -   Apply the feynman technique with an LLM
        \\  habit    -   Habit tracking/management
        \\  fetch    -   Fetch tracked statistics
        , .{}
    );

    posix.exit(1);
}

pub fn main() !void {
    const argv = std.os.argv;
    if (argv.len < 2) usage();

    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer assert(gpa.deinit() == .ok);
    const gpa_allocator = gpa.allocator();

    switch (commands.get(mem.span(argv[1])) orelse .mismatch) {
        .net => @import("commands/net.zig").command(argv[1..]),
        .habit => @import("commands/habit.zig").command(argv[1..]),
        .feynman => @import("commands/feynman.zig").command(argv[1..]),
        .search => @import("commands/search.zig").command(argv[1..]),
        .fetch => @import("commands/fetch.zig").command(argv[1..]),
        .mismatch => usage(),
    }

    const config_lines = read_config_from_argv(gpa_allocator, argv);
    defer gpa_allocator.free(config_lines);
}

const Config = struct {
    const Self = @This();

    knowledge_base_path: []const u8,
    net_levels: []const NetLevel = &.{
        .{ .sites = null, .transition_hours = .all, .time_hours = .unlimited }
    },

    const NetLevel = struct {
        sites: ?[][]const u8,
        transition_hours: HourSet,
        time_hours: Duration,

        const Duration = enum(u8) { unlimited = 0, _ };
        const HourSet = union(enum) { all, some: []const u8 };
    };

    pub fn parse_from_zon(zon: []const u8) Self {
        // TODO: parse ~/.config/quartz/quartz.zon
        _ = zon;
        return .{};
    }
};

// TODO: return errors because exit() skips defers.
fn read_config_from_argv(allocator: std.mem.Allocator, argv: [][*:0]u8) []const u8 {
    const home_path = posix.getenv("HOME") orelse {
        log.err("HOME env variable was unset.", .{});
        posix.exit(1);
    };

    var config_path: []const u8 = "~/.config/quartz/quartz.zon";
    var joined_path = false;

    for (argv, 0..) |c_arg, i| {
        const arg = mem.span(c_arg);

        if (mem.eql(u8, arg, "-c")) {
            if (argv.len > i + 1) {
                config_path = mem.span(argv[i + 1]);
                break;
            } else usage();
        } else if (mem.startsWith(u8, arg, "--config="))  {
            var split = mem.splitAny(u8, arg, "=");
            _ = split.first();
            config_path = split.next().?;

            if (config_path.len == 0) {
                log.err("no config path passed.", .{});
                posix.exit(1);
            }
            break;
        }
    }

    if (config_path[0] == '~') {
        config_path = fs.path.join(allocator, &.{ home_path, config_path[1..] }) catch unreachable;
        joined_path = true;
    } else if (config_path[0] != '/') {
        // not ~/foo and not /foo -> foo/bar relative to .
        var cwd_absolute_buffer: [fs.max_path_bytes]u8 = undefined;
        const cwd_abs = fs.cwd().realpath(".", &cwd_absolute_buffer) catch unreachable;

        config_path = fs.path.join(allocator, &.{ cwd_abs, config_path }) catch unreachable;
        joined_path = true;
    }

    defer if (joined_path) allocator.free(config_path);

    var config_file = fs.openFileAbsolute(config_path, .{ .mode = .read_only }) catch |e| {
        log.err("failed opening config file {s} ({})", .{ config_path, e });
        posix.exit(1);
    };
    defer config_file.close();

    if ((config_file.stat() catch @panic("stat")).kind != .file) {
        log.err("{s} is a directory", .{ config_path });
        posix.exit(1);
    }

    var config_fr = config_file.reader(&.{});
    return config_fr.interface.allocRemaining(allocator, .unlimited) catch unreachable;
}
