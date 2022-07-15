"Example of a rule that can version-stamp its outputs"

load("//lib:stamping.bzl", "STAMP_ATTRS", "stamp_files")

def _stamp_aware_rule_impl(ctx):
    args = ctx.actions.args()
    inputs = []
    outputs = [ctx.outputs.out]
    stamp = stamp_files(ctx)
    if stamp:
        args.add("--volatile_status_file", stamp.volatile_status)
        args.add("--stable_status_file", stamp.stable_status)

        inputs.extend([stamp.volatile_status, stamp.stable_status])

    ctx.actions.run_shell(
        inputs = inputs,
        arguments = [args],
        outputs = outputs,
        # In reality, this program would also read from the status files.
        command = "echo $@ > " + outputs[0].path,
    )
    return [DefaultInfo(files = depset(outputs))]

my_stamp_aware_rule = rule(
    implementation = _stamp_aware_rule_impl,
    attrs = dict({
        "out": attr.output(mandatory = True),
    }, **STAMP_ATTRS),
)
