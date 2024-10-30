Hello! This repo involves a static website that's hosted on S3 with ClouFront for CDN.
This config also incorporates a custom domain with Route 53. 
This architecture is great if cost is important to you, as S3 charges you based on storage used
and data transferred. You pay for what you consume. It's also serverless, which is also great for
reducing costs. 
S3 has automatic scaling and can handle high traffic without the need for provisioning resources. 
Because ClouFront uses a edge locations, it allows for fast content delivery regardless of user
location, which will improve user experience. 
