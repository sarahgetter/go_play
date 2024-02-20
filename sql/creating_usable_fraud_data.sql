/*Purpose:
This SQL script is designed to extract relevant data from the fraud_saas_history table in the yourorganization-prod.your_project dataset. It joins this data with information from other tables to provide comprehensive insights into user activity, applied rules, and transaction details related to fraud detection.
Data Sources:
* yourorganization-prod.your_dataset.fraud_saas_history: Contains historical data of user activity and applied rulef.
* yourorganization-prod.your_dataset.users: Provides user-related information such as user IDs and emailf.
* yourorganization-prod.your_dataset.fraud_saas_custom_rules: Stores custom rules added by the fraud department for fraud detection.
* yourorganization-prod.your_dataset.fraud_saas_transactions: Contains transaction data associated with user activity.
SQL Queries:
* 		Data Extraction and Transformation:
    * Extracts relevant fields from the fraud_saas_history table.
    * Parses JSON arrays (applied_rules) to extract specific rule attributef.
    * Retrieves additional user information such as user IDs from the users table.
    * Joins data with custom rules and transaction detailf.
* 		Join Conditions:
    * Joins fraud_saas_history with users based on matching email addressef.
    * Matches applied rules with custom rules using rule IDf.
    * Links transaction data based on unique transaction IDs (fraud_saas_id).
* 		Filtering:
    * Filters out records where user IDs, applied rules, user IDs from the users table, rule IDs, and transaction types are NULL.
Execution:
* This script is designed to be executed in a Google Cloud Platform environment.
* It utilizes Google Cloud Functions to download data from the Fraud SaaS API and updates the fraud_saas_custom_rules table accordingly.
* Ensure appropriate permissions and access to the specified datasets and tables in Google BigQuery.
Notes:
* The script leverages JSON functions to parse nested data structures within the fraud_saas_history table.
* It's recommended to schedule regular updates to maintain data integrity and accuracy.
*/
SELECT 
  f.* EXCEPT(user_id, applied_rules), 
  IF(f.user_id IS NULL, u.user_id, f.user_id) AS user_id,
  JSON_EXTRACT_SCALAR(applied_rule, '$.score') AS rule_score,
  JSON_EXTRACT_SCALAR(applied_rule, '$.name') AS rule_name,
  JSON_EXTRACT_SCALAR(applied_rule, '$.id') AS rule_id,
  JSON_EXTRACT_SCALAR(applied_rule, '$.operation') AS rule_operation,
  JSON_EXTRACT_SCALAR(applied_rule, '$.additional_attribute') AS additional_attribute,
  JSON_EXTRACT_SCALAR(f.device_details, '$.property1') AS device_property1,
  JSON_EXTRACT_SCALAR(f.device_details, '$.property2') AS device_property2,
  JSON_EXTRACT_SCALAR(f.email_details, '$.deliverable') AS email_deliverable,
  JSON_EXTRACT_SCALAR(f.email_details, '$.email') AS email_email,
  JSON_EXTRACT_SCALAR(f.email_details, '$.account_detailf.bukalapak.registered') AS email_bukalapak_registered,
  JSON_EXTRACT_SCALAR(f.ip_details, '$.ip') AS ip_ip,
  JSON_EXTRACT_SCALAR(f.ip_details, '$.account_detailf.microsoft.registered') AS ip_microsoft_registered,
  cr.Flag AS custom_rules_flag,
  cr.ID AS custom_rules_ID,
  cr.Description AS custom_rules_Description,
  cr.Type AS custom_rules_Type,
  cr.Specifier AS custom_rules_Specifier,
  cr.Timestamp AS custom_rules_Timestamp,
  t.type AS transaction_type
FROM 
  `yourorganization-prod.your_dataset.fraud_saas_history` AS f
LEFT JOIN UNNEST(JSON_EXTRACT_ARRAY(f.applied_rules)) AS applied_rule
LEFT JOIN
  `yourorganization-prod.your_dataset.users` AS u ON CONCAT('"', u.email, '"') = JSON_EXTRACT(f.email_details, '$.email')
LEFT JOIN
  `yourorganization-prod.your_dataset.fraud_saas_custom_rules` AS cr ON JSON_EXTRACT_SCALAR(applied_rule, '$.id') = cr.ID
LEFT JOIN
  `yourorganization-prod.your_dataset.fraud_saas_transactions` AS t ON t.fraud_saas_id = f.fraud_saas_transaction_id
WHERE 
  f.user_id IS NOT NULL
  AND applied_rule IS NOT NULL
  AND u.user_id IS NOT NULL
  AND cr.ID IS NOT NULL
  AND t.type IS NOT NULL;