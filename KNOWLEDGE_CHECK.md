# Lab 09: Knowledge check

**Answer each question below it, in your own words, in one to three sentences.** Replace the `...` below **Your answer:** with your text.

## 1. Credentials in the image?

Assume you want to share your image with others and make it publicly available on `ghcr.io`, so that anyone can pull it and run the analysis. A teammate suggests adding `COPY .aws /home/app/.aws` to the `Dockerfile`, so that nobody has to type `-v ~/.aws:/home/app/.aws:ro` any more. (This is a thought experiment: keep your own package private.)

**Your answer:** Give two reasons why this is a bad idea. Think of who could then read your credentials, and of what happens when your Learner Lab session ends.

Copying AWS credentials into the Docker image is a security risk because anyone who downloads the image could potentially access them. Also, Learner Lab credentials expire, so the credentials stored in the image would eventually stop working.

## 2. Where did the Atlas password come from?

In Step 4, you ran the analysis once with `-v ~/.aws:/home/app/.aws:ro` only, without the three `-e` options. The container still wrote to your Atlas cluster.

*Hint:* Read `get_atlas_settings()` in `src/book_analysis/analyze.py`.

**Your answer:** Explain, step by step, where the container found the Atlas settings in that run.

The container first accessed my AWS Learner Lab credentials through the mounted .aws directory. Since I didn't provide the three MongoDB environment variables, get_atlas_settings() used boto3 to retrieve and decrypt the mongodb_credentials parameter from AWS Systems Manager Parameter Store. It then used the retrieved URL, username, and password to connect to MongoDB Atlas.

## 3. Same tag, different image

Run `docker images book-analysis`, and note the image ID of `book-analysis:0.1.0`. Then change the `description` in the `LABEL` of your `Dockerfile`, build again with the same command, `docker build -t book-analysis:0.1.0 .`, and run `docker images book-analysis` again.

**Your answer:** Paste the image ID from before and after the rebuild. Why is it a problem for someone who uses your image that `0.1.0` now names a different image, and what should you have done instead?

Before rebuilding, my image ID was 05b762f5595a, and after rebuilding, it changed to d75d738c46f5. Reusing the same 0.1.0 tag for a different image can cause confusion because users might receive different versions even though the tag is the same. Instead, I should have assigned the updated image a new version tag, such as 0.1.1.
