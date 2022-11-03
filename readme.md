# klm-aws-pkr-amz2

## Description

Packer ami builder for Amazon 2. Builds are performed in us-west-2. Amis are copied to us-east-1, us-east-2, and us-west-1 after a successful build.

Builds are triggered by commits to the main branch with a commit message of 'build'

AWS authentication requires setting up an OIDC provider with a trust to github with the role arn added as AWS_OIDC_ROLE in the github repo secrets

To execute build of an empty commit

```bash
git commit -m 'build' --allow-empty
git push origin main
```

To execute build locally, do the following:

Set local environment vars for aws auth

```bash
export AWS_PROFILE=${profile_name}
export AWS_REGION=${region_name}
```

```bash
git clone https://github.com/kikrr/kikrr-aws-pkr-amz2.git
```

```bash
cd ./src
```

```bash
packer init .
```

```bash
packer build template.pkr.hcl
```