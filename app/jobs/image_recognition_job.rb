class ImageRecognitionJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find(post_id)

    client = Aws::Rekognition::Client.new(
      region: Rails.application.credentials.aws[:region],
      access_key_id: Rails.application.credentials.aws[:access_key_id],
      secret_access_key: Rails.application.credentials.aws[:secret_access_key]
    )

    # Use the uploaded image file in the S3 bucket
    image = { s3_object: { bucket: 'daijiroappbucket', name: "uploads/post/image/#{post.id}/#{post.image.file.filename}" } }
    response = client.detect_labels(image: image)

    if response.labels.any? { |label| label.name == 'Nature' && label.confidence > 90.0 }
      # If the image is a landscape image, do nothing.
    else
      # If the image is not a landscape image, delete the post.
      post.destroy
    end
  end
end
