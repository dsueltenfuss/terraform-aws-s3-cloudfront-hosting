# terraform-aws-cloudfront-hosting
A terraform module to configure a cloudfront and SSL certificate for an existing S3 website.

### Module Variables

`website_address`
- The URL of the website you are hosting

`s3_bucket_name`
- The name of the existing S3 bucket 

`route_53_zone`
- The name of the Route 53 zone in yoru AWS account to create the DNS entries in

`workspaces` (optional)
- A list of workspaces to create the resources for. If empty, it will create for all workspaces.

## Contributing

Contributions are welcome.
To contribute please read the [CONTRIBUTING](CONTRIBUTING.md) document.

All contributions are subject to the license and in no way imply compensation for contributions.
