# Load required libraries
library(paws)
library(tibble)
library(readr)
library(magick)
library(aws.s3)
library(purrr)

# Set up AWS credentials
Sys.setenv (
  "AWS_ACCESS_KEY_ID" = "AKIAULC7Z3LRGWACXKVK",
  "AWS_SECRET_ACCESS_KEY" = "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",
  "AWS_DEFAULT_REGION" = "ap-southeast-2"
)
# Section 3: Image Recognition for Text in Image Task
# Initialize connection to AWS S3
s3 <- s3()

# List existing buckets
buckets <- s3$list_buckets()
length(buckets$Buckets)

# Create a new S3 bucket
s3 <- s3()
s3$create_bucket(Bucket = "ravi-assesmentbucket", CreateBucketConfiguration = list(LocationConstraint = "ap-southeast-2" ))

# List buckets (after creation)
buckets <- s3$list_buckets()
buckets <- map_df(buckets[[1]],
                  ~tibble(name = .$Name, creationDate = .$CreationDate))

# Select a specific bucket
my_bucket2 <- buckets$name[buckets$name == "ravi-assesmentbucket"]

# List objects in the selected bucket
bucket_objects <- s3$list_objects(my_bucket2) %>% 
  .[["Contents"]] %>% 
  map_chr("Key") 
bucket_objects

# Upload an image to the selected bucket
s3$put_object(Bucket = my_bucket2, 
              Body = read_file_raw("aws.jpeg"), 
              Key = "aws.jpeg")

# Select a different bucket for later use
my_bucket2 <- buckets$name[buckets$name == "ravi-assesmentbucket"]
bucket_objects <- s3$list_objects(my_bucket2) %>% 
  .[["Contents"]] %>% 
  map_chr("Key") 
bucket_objects

# Initialize connection to AWS Rekognition
rekognition <- rekognition()

# Referencing an image in an Amazon S3 bucket
resp <- rekognition$detect_text(
  Image = list(
    S3Object = list(
      Bucket = my_bucket2,
      Name = bucket_objects
    )
  )
)

# Parsing the response
resp %>%
  .[["TextDetections"]] %>%
  keep(~.[["Type"]] == "WORD") %>%
  map_chr("DetectedText") 

# Section 4: Image Recognition for Compare Faces Task
# Read images for comparison
thief <- readr::read_file_raw("face_detect1.jpg") 
suspects <- readr::read_file_raw("face_detect2.jpg")

# Compare the faces endpoint
resp <- rekognition$compare_faces(
  SourceImage = list(
    Bytes = thief
  ),
  TargetImage = list(
    Bytes = suspects
  )
)

# identify the length of the UnmatchedFaces
length(resp$UnmatchedFaces)

# identify the length of the FaceMatches
length(resp$FaceMatches)

# Compare the 2 faces (Unmatched vs. FaceMatch)
# Displays the accuracy of the predicted result against the similarity
resp$FaceMatches[[1]]$Similarity

# Convert raw image into a magik object
suspects <- image_read(suspects)

# Extract face match from the response
match <- resp$FaceMatches[[1]]

# Calculate bounding box properties
width <-match$Face$BoundingBox$Width * image_info(suspects)$width
height <-match$Face$BoundingBox$Height * image_info(suspects)$height
left <-match$Face$BoundingBox$Left * image_info(suspects)$width
top <-match$Face$BoundingBox$Top * image_info(suspects)$height

# Add bounding box to suspects image 
image <- suspects %>%
  image_draw()
rect(left, top, left + width, top + height, border = "red", lty = "dashed", lwd = 5)
image

