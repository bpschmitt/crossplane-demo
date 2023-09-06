provider "newrelic" {
    source  = "newrelic/newrelic"
    account_id = var.nr_account_id
    api_key = var.nr_api_key
    region = var.nr_region
}

resource "newrelic_alert_policy" "kubernetes_alert_policy" {
    name = var.nr_alert_policy_name
}

resource "newrelic_nrql_alert_condition" "container_is_restarting" {
    policy_id                    = newrelic_alert_policy.kubernetes_alert_policy.id
    type                         = "static"
    name                         = "Container is Restarting"
    description                  = "Alert when the container restart count is greater than 0 in a sliding 5 minute window"
    runbook_url                  = ""
    enabled                      = true
    violation_time_limit_seconds = 21600
    fill_option                    = null
    fill_value                     = null
    aggregation_window             = 300
    aggregation_method             = "event_flow"
    aggregation_delay              = 60
    expiration_duration            = 300
    open_violation_on_expiration   = false
    close_violations_on_expiration = true
    slide_by                       = 60

    nrql {
        query             = "from K8sContainerSample select sum(restartCountDelta) where clusterName in ('${var.nr_cluster_name}') and namespaceName in ('newrelic','kube-system') and namespaceName not in ('') FACET containerName, podName, namespaceName, clusterName"
    }

    critical {
        operator              = "above"
        threshold             = 0
        threshold_duration    = 300
        threshold_occurrences = "ALL"
    }
}

resource "newrelic_nrql_alert_condition" "container_high_cpu_util" {
    policy_id                    = newrelic_alert_policy.kubernetes_alert_policy.id
    type                         = "static"
    name                         = "Container high cpu utilization"
    description                  = "Alert when the average container CPU Utilization (vs. Limit) is > 90% for more than 5 minutes"
    runbook_url                  = ""
    enabled                      = true
    violation_time_limit_seconds = 21600
    fill_option                    = null
    fill_value                     = null
    aggregation_window             = 300
    aggregation_method             = "event_flow"
    aggregation_delay              = 60
    evaluation_delay               = 60
    expiration_duration            = 300
    open_violation_on_expiration   = false
    close_violations_on_expiration = true
    slide_by                       = 60


    nrql {
        query             = "from K8sContainerSample select average(cpuCoresUtilization) where clusterName in ('${var.nr_cluster_name}') and namespaceName not in ('') facet containerName, podName, namespaceName, clusterName"
    }

    critical {
        operator              = "above"
        threshold             = 90
        threshold_duration    = 300
        threshold_occurrences = "ALL"
    }
}