const std = @import("std");
const mem = std.mem;
const meta = std.meta;
const log = std.log;

const Commands = enum { net, habit, feynman, search, fetch, mismatch };
const commands: std.StaticStringMap(Commands) = .initComptime(.{
    .{ "net", .net },
    .{ "habit", .habit },
    .{ "feynman", .feynman },
    .{ "search", .search },
    .{ "fetch", .fetch },
});

pub fn main() !void {
    const argv = std.os.argv;
    if (argv.len < 2) usage();

    switch (commands.get(mem.span(argv[1])) orelse .mismatch) {
        .net => @import("commands/net.zig").command(argv[1..]),
        .habit => @import("commands/habit.zig").command(argv[1..]),
        .feynman => @import("commands/feynman.zig").command(argv[1..]),
        .search => @import("commands/search.zig").command(argv[1..]),
        .fetch => @import("commands/fetch.zig").command(argv[1..]),
        .mismatch => usage(),
    }
}


fn usage() noreturn {
    log.err(
        \\incorrect command.
        \\usage: quartz [command] [options]
        \\
        \\Commands:
        \\  net      -   Internet access control
        \\  habit    -   Habit tracking/management
        \\  feynman  -   Apply the feynman technique with an LLM
        \\  search   -   Semantic search engine over local knowledge base
        \\  fetch    -   Fetch tracked statistics
        , .{}
    );

    std.posix.exit(1);
}
