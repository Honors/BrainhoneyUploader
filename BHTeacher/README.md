# Teacher Edition
The Teacher Edition of the Brainhoney Uploader is very similar to the
studetn edition currently. Although the file input will remain the same,
the embedded-browser method will need to be replaced.

The new version of iOS does not allow cookie access in webviews, which
would be required for the uploading to be possible.

## Interface
The interface is largely the same as the student edition, with a different
icon color and eventually without the web browser.

## Implementation
Uploading teacher assets is very easy in Brainhoney. The upload and submit
processes are separated out, simplifying our job.

In the first version, which does not work with the new cookie restrictions of
iOS 7, a web browser is used to capture the cookie of the authenticated user,
and a cached file is then uploaded for later access.

## Todo
- Allow for file downloads.
- Render status bar based on activity.
