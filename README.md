
This repository is primarily hosted on Gitea, in addition to this the `staging` and `master` branches are mirrored on [Github](https://github.com/FugaCloud/s3-sync-action).

---

# GitHub Action to sync directories to Object Storage Buckets 🔄

This simple action uses the [rclone CLI](https://rclone.org/s3/) to sync a directory (either from your repository or generated during your workflow) with a remote Object Storage bucket. Previously it used the AWS S3 CLI, however since version `2.0.0` this has been replaced with rclone.


## Usage

### `workflow.yml` Example

Place in a `.yml` file such as this one in your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

It is also possible to add your own required args for `rclone sync`, including [S3 specific](https://rclone.org/s3/) args for rclone.

#### The following example includes optimal defaults for a public static website:

- `--s3-acl public-read` makes your files publicly readable.
- `--links` won't hurt and fixes some weird symbolic link problems that may come up.
- Most importantly, take note of the default behaviour of `rclone sync`, as it for example deletes any files from the destination which no longer present on the source. This may or may not be what you intend.
- **Optional tip:** If you're uploading the root of your repository, adding `--exclude '.git/*'` prevents your `.git` folder from syncing, which would expose your source code history if your project is closed-source. (To exclude more than one pattern, you must have one `--exclude` flag per exclusion. The single quotes are also important!)

```yaml
name: Upload Website

on:
  push:
    branches:
    - master

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: FugaCloud/s3-sync-action@2.0.0
      with:
        args: --s3-acl public-read -v --links
      env:
        ACCESS_KEY_ID: ${{ secrets.CYSO_CLOUD_AMS_OBJECT_STORAGE_KEY_ID }}
        SECRET_ACCESS_KEY: ${{ secrets.CYSO_CLOUD_AMS_OBJECT_STORAGE_SECRET }}
        ENDPOINT: https://core.fuga.cloud:8080
        BUCKET: "staticsites"
        REGION: "ams"
        SOURCE_DIR: 'build'
        DEST_DIR: 'mywebsite'
```


### Configuration

The following settings must be passed as environment variables as shown in the example. Sensitive information, especially `ACCESS_KEY_ID` and `SECRET_ACCESS_KEY`, should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) — otherwise, they'll be public to anyone browsing your repository's source code and CI logs.

| Key | Value | Suggested Type | Required | Default |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| `ACCESS_KEY_ID` | Your Access Key ID. [More info here.](https://docs.cyso.cloud/object-storage/getting-started/#using-the-dashboard) | `secret env` | **Yes** | N/A |
| `SECRET_ACCESS_KEY` | Your Secret Access Key. [More info here.](https://docs.cyso.cloud/object-storage/getting-started/#using-the-dashboard) | `secret env` | **Yes** | N/A |
| `BUCKET` | The name of the bucket you're syncing to. For example, `eu-west-1` or `fra`. | `env` | No | N/A |
| `REGION` | The region where you created your bucket. Not set by default. | `env` | No | N/A |
| `ENDPOINT` | The endpoint URL of the bucket you're syncing to. For example for region Frankfurt of Cyso Cloud this is `https://fra.fuga.cloud:8080`. | `env` | No | Defaults to AWS |
| `SOURCE_DIR` | The local directory (or file) you wish to sync/upload to the bucket. For example, `public`. Defaults to the current working dir. | `env` | No | `./` |
| `DEST_DIR` | The directory inside of the bucket you wish to sync/upload to. For example, `my_project/assets`. Defaults to the root of the bucket. | `env` | No | `/` (root of bucket) |

## Looking for affordable Object Storage?

Cyso Cloud offers a state of the art Object Storage solution compatible with the AWS S3 API. This is fully powered by NVMe storage offered at great value. More info can be found at https://cyso.cloud/services/object-storage/.

## License

This project is distributed under the [MIT license](LICENSE.md).
