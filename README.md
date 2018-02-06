# terraform-abort-state-empty-repro

slow test:

    GOOGLE_PROJECT=google_project_name terraform apply -auto-approve
    GOOGLE_PROJECT=google_project_name TF_LOG=trace terraform apply -auto-approve -var changeme=2
    # let run for some time
    # ^C
    # let run for some time
    # ^C
    cat terraform.tfstate   # empty!

fast test:

    # no state
    GOOGLE_PROJECT=google_project_name terraform apply -auto-approve
    # let run for some time
    # ^C
    # let run for some time
    # ^C
    cat terraform.tfstate   # empty!

## trace

from the second ^C onwards

    018-02-06T11:05:59.088+0200 [DEBUG] plugin.terraform-provider-google_v1.5.0_x4: 2018/02/06 11:05:59 [DEBUG] Progress of operation "operation-1517907844015-f2a2cb96": "RUNNING"
    2018-02-06T11:05:59.088+0200 [DEBUG] plugin.terraform-provider-google_v1.5.0_x4: 2018/02/06 11:05:59 [TRACE] Waiting 10s before next try
    2018/02/06 11:06:03 [TRACE] dag/walk: vertex "root", waiting for: "provider.google (close)"
    2018/02/06 11:06:03 [TRACE] dag/walk: vertex "meta.count-boundary (count boundary fixup)", waiting for: "module.testing_node_pool.google_container_node_pool.autoscaling"
    2018/02/06 11:06:03 [TRACE] dag/walk: vertex "provider.google (close)", waiting for: "module.testing_node_pool.google_container_node_pool.autoscaling"
    module.testing_node_pool.google_container_node_pool.autoscaling: Still modifying... (ID: europe-west1-b/tf-state-repro/default, 2m0s elapsed)
    ^C2018/02/06 11:06:04 [DEBUG] plugin: waiting for all plugin processes to complete...
    Two interrupts received. Exiting immediately. Note that data
    loss may have occurred.
    2018/02/06 11:06:04 [TRACE] root.testing_node_pool: eval: *terraform.EvalWriteState
    2018/02/06 11:06:04 [TRACE] root.testing_node_pool: eval: *terraform.EvalApplyProvisioners
    2018/02/06 11:06:04 [TRACE] root.testing_node_pool: eval: *terraform.EvalIf
    2018/02/06 11:06:04 [TRACE] root.testing_node_pool: eval: *terraform.EvalWriteState
    2018/02/06 11:06:04 [TRACE] root.testing_node_pool: eval: *terraform.EvalWriteDiff
    2018/02/06 11:06:04 [TRACE] root.testing_node_pool: eval: *terraform.EvalApplyPost
    2018/02/06 11:06:04 [WARN] Early exit triggered by hook: *terraform.stopHook
    2018/02/06 11:06:04 [TRACE] root.testing_node_pool: eval: *terraform.EvalApplyPost, err: early exit
    2018/02/06 11:06:04 [TRACE] root.testing_node_pool: eval: *terraform.EvalSequence, err: early exit
    2018/02/06 11:06:04 [TRACE] [walkApply] Exiting eval tree: module.testing_node_pool.google_container_node_pool.autoscaling
    2018/02/06 11:06:04 [TRACE] dag/walk: walking "meta.count-boundary (count boundary fixup)"
    2018/02/06 11:06:04 [TRACE] vertex 'root.meta.count-boundary (count boundary fixup)': walking
    2018/02/06 11:06:04 [TRACE] dag/walk: walking "provider.google (close)"
    2018/02/06 11:06:04 [TRACE] vertex 'root.provider.google (close)': walking
    2018/02/06 11:06:04 [TRACE] vertex 'root.meta.count-boundary (count boundary fixup)': evaluating
    2018/02/06 11:06:04 [TRACE] [walkApply] Entering eval tree: meta.count-boundary (count boundary fixup)
    2018/02/06 11:06:04 [TRACE] root: eval: *terraform.EvalCountFixZeroOneBoundaryGlobal
    2018/02/06 11:06:04 [TRACE] vertex 'root.provider.google (close)': evaluating
    2018/02/06 11:06:04 [TRACE] EvalCountFixZeroOneBoundaryGlobal: count 1, search "google_container_cluster.cluster.0", replace "google_container_cluster.cluster"
    2018/02/06 11:06:04 [TRACE] [walkApply] Entering eval tree: provider.google (close)
    2018/02/06 11:06:04 [TRACE] root: eval: *terraform.EvalCloseProvider
    2018/02/06 11:06:04 [TRACE] [walkApply] Exiting eval tree: provider.google (close)
    2018/02/06 11:06:04 [TRACE] EvalCountFixZeroOneBoundaryGlobal: count 1, search "data.google_compute_zones.available.0", replace "data.google_compute_zones.available"
    2018/02/06 11:06:04 [TRACE] EvalCountFixZeroOneBoundaryGlobal: count 1, search "data.google_container_cluster.cluster.0", replace "data.google_container_cluster.cluster"
    2018/02/06 11:06:04 [TRACE] EvalCountFixZeroOneBoundaryGlobal: count 1, search "google_container_node_pool.autoscaling.0", replace "google_container_node_pool.autoscaling"
    2018/02/06 11:06:04 [TRACE] EvalCountFixZeroOneBoundaryGlobal: count 1, search "data.google_container_cluster.cluster.0", replace "data.google_container_cluster.cluster"
    2018/02/06 11:06:04 [TRACE] [walkApply] Exiting eval tree: meta.count-boundary (count boundary fixup)
    2018/02/06 11:06:04 [TRACE] dag/walk: walking "root"
    2018/02/06 11:06:04 [TRACE] vertex 'root.root': walking
    2018-02-06T11:06:04.474+0200 [DEBUG] plugin.terraform-provider-google_v1.5.0_x4: plugin received interrupt signal, ignoring: timestamp=2018-02-06T11:06:04.473+0200 count=2
    2018/02/06 11:06:04 [WARN] terraform: stop complete
    2018/02/06 11:06:04 [TRACE] Preserving existing state lineage "556cf647-6cca-4fea-9944-cd6ebd2fd432"
    2018-02-06T11:06:04.477+0200 [DEBUG] plugin: plugin process exited: path=/Users/mpa/dev/terraform-repro-abort-empties-state/.terraform/plugins/darwin_amd64/terraform-provider-google_v1.5.0_x4
    2018/02/06 11:06:04 [TRACE] Preserving existing state lineage "556cf647-6cca-4fea-9944-cd6ebd2fd432"