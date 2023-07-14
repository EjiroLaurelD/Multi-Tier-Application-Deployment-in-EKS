Create a bucket with a globally unique name in the correct region
Block all public access
Enable bucket versioning
Enable encryption & select AWS Key Management Service key (SSE-KMS)
Click create KMS key(leave defaults), select a user who has access to all permissions and click finish.
Get the whole alias ARN from the KMS dashboard & paste it into the box
Leave bucket key enabled
After creating the bucket, go into the permissions and edit the policy and add the following policy and save the changes.

A simple way to get your user ARN is to enter the following command.

```aws sts get-caller-identity```
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "<your_user_arn>"
            },
            "Action": "s3:ListBucket",
            "Resource": "<your_bucket_arn>"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "<your_user_arn>"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "<your_bucket_arn>/*"
        }
    ]
}
```
