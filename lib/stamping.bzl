"Public API"

load("//lib/private:stamping.bzl", "is_stamping_enabled")

def stamp_files(ctx):
    """Provide the files that contain the result of the --workspace_status_command.

    Returns:
        If stamping is not enabled for the current build, returns None.
        Otherwise, returns a struct containing (volatile_status, stable_status) keys
    """
    if is_stamping_enabled(ctx.attr):
        return struct(
            volatile_status = ctx.version_file,
            stable_status = ctx.info_file,
        )

    return None

STAMP_ATTRS = {
    "stamp": attr.int(
        doc = """\
Whether to encode build information into the output. Possible values:

    - `stamp = 1`: Always stamp the build information into the output, even in
        [--nostamp](https://docs.bazel.build/versions/main/user-manual.html#flag--stamp) builds.
        This setting should be avoided, since it is non-deterministic.
        It potentially causes remote cache misses for the target and
        any downstream actions that depend on the result.
    - `stamp = 0`: Never stamp, instead replace build information by constant values.
        This gives good build result caching.
    - `stamp = -1`: Embedding of build information is controlled by the
        [--[no]stamp](https://docs.bazel.build/versions/main/user-manual.html#flag--stamp) flag.
        Stamped targets are not rebuilt unless their dependencies change.
        """,
        default = -1,
        values = [1, 0, -1],
    ),
}
