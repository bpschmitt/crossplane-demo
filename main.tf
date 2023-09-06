provider "newrelic" {
    account_id = var.nr_account_id
    api_key = var.nr_api_key
    region = var.nr_region
}

module "crossplane-newrelic" {
  source  = "./module"
}