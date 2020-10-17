import typer
import boto3


def run_train(path_to_zip: str):
    version_name = f''
    typer.echo(f"Compressing {path_to_zip}")

    typer.echo(f"Uploading to s3 {path_to_zip}")
    s3 = boto3.resource('s3')
    s3.meta.client.upload_file('/tmp/hello.txt', 'gene', 'hello.txt')
