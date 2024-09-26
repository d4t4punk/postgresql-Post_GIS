import requests
from behave import given, when, then

@given('a public cloud file URL "{file_url}"')
def step_given_public_cloud_file_url(context, file_url):
    context.file_url = file_url

@when('I check if the file exists on the cloud')
def step_when_check_file_exists_on_cloud(context):
    response = requests.head(context.file_url)
    context.file_exists = response.status_code == 200

@then('the file should exist on the cloud')
def step_then_file_should_exist_on_cloud(context):
    assert context.file_exists, f"The file at '{context.file_url}' does not exist."