import boto3
import datetime
import os
import urllib3
import json

n_days = 7
today = datetime.datetime.today()
http = urllib3.PoolManager()
start_of_current_month = today.replace(day=1)

def lambda_handler(event, context):
    group_by = os.environ.get("GROUP_BY", "SERVICE")
    length = int(os.environ.get("LENGTH", "5"))
    cost_aggregation = os.environ.get("COST_AGGREGATION", "UnblendedCost")

    MessegeSum, data = report_cost(group_by=group_by, length=length, cost_aggregation=cost_aggregation)

    slack_hook_url = os.environ.get('SLACK_WEBHOOK_URL')
    if slack_hook_url:
        publish_slack(slack_hook_url, MessegeSum, data)

def report_cost(group_by: str = "SERVICE", length: int = 5, cost_aggregation: str = "UnblendedCost", result: dict = None, yesterday: str = None, new_method=True):
    # Get account account name from env, or account id/account alias from boto3
    account_name = os.environ.get("AWS_ACCOUNT_NAME", None)
    if account_name is None:
        iam = boto3.client("iam")
        paginator = iam.get_paginator("list_account_aliases")
        for aliases in paginator.paginate(PaginationConfig={"MaxItems": 1}):
            if "AccountAliases" in aliases and len(aliases["AccountAliases"]) > 0:
                account_name = aliases["AccountAliases"][0]

    if account_name is None:
        account_name = boto3.client("sts").get_caller_identity().get("Account")

    if account_name is None:
        account_name = "[NOT FOUND]"

    client = boto3.client('ce')

    query = {
        "TimePeriod": {
            "Start": start_of_current_month.strftime('%Y-%m-%d'),
            "End": today.strftime('%Y-%m-%d'),
        },
        "Granularity": "MONTHLY",
        "Filter": {
            "Not": {
                "Dimensions": {
                    "Key": "RECORD_TYPE",
                    "Values": [
                        "Credit",
                        "Refund",
                        "Upfront",
                        "Support",
                    ]
                }
            }
        },
        "Metrics": [cost_aggregation],
        "GroupBy": [
            {
                "Type": "DIMENSION",
                "Key": group_by,
            },
        ],
    }
    
    data = client.get_cost_and_usage(**query)
    results = {}
    sum = 0
    for result in data['ResultsByTime']:
        for group in result['Groups']:
            key = group['Keys'][0]
            total = group['Metrics']['UnblendedCost']['Amount']
            sum = sum + float(total)
            results[key] = f"{float(total):,.2f}"
    results['Total costs'] = f"{sum:,.2f}"
    MessegeSum = f"Total cost for account {account_name} was ${sum:,.2f}"
    return MessegeSum, objects_to_table(results)


def publish_slack(hook_url, summary, buffer):
    message = json.dumps({
            "text": summary + "\n\n```\n" + buffer + "\n```",
        })
    resp = http.request("POST", url=hook_url, body=message)

    return resp

def objects_to_table(results):
    if not results:
        return ''

    sorted_results = sorted(results.items(), key=lambda x: float(x[1]), reverse=True)

    max_key_length = max(len(key) for key, _ in sorted_results)
    max_value_length = max(len(value) for _, value in sorted_results)

    table = f"| {'Services':<{max_key_length}} | {'Service total':>{max_value_length}} |\n"
    table += f"| {'-' * max_key_length} | {'-' * max_value_length}         |\n"

    for key, value in sorted_results:
        table += f"| {key:<{max_key_length}} | {value:>{max_value_length}}         |\n"

    return table
