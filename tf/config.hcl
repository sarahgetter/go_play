provider "google" {
  # Provider configuration
  credentials = file("<PATH_TO_YOUR_SERVICE_ACCOUNT_KEY.json>")
  project     = "<YOUR_PROJECT_ID>"
  region      = "<YOUR_REGION>"
}

resource "google_project_iam_custom_role" "data_scientist_role" {
  role_id     = "dataScientistRole"
  title       = "Data Scientist Role"
  description = "A custom role for data scientists"
  permissions = [
    "bigquery.datasets.get",
    "bigquery.jobs.create",
    "bigquery.tables.get",
    "bigquery.tables.list",
    "storage.objects.get",
    "storage.objects.list",
    # Add other necessary permissions
  ]
}

resource "google_project_iam_policy" "data_scientist_policy" {
  project     = "<YOUR_PROJECT_ID>"
  policy_data = data.google_iam_policy.data_scientist_policy.policy_data
}

data "google_iam_policy" "data_scientist_policy" {
  binding {
    role = google_project_iam_custom_role.data_scientist_role.id

    members = [
      "user:example-user@example.com",
      # Add other members who should assume this role
    ]
  }
}
