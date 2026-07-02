import os
import boto3
import pandas as pd
from datetime import datetime
from dotenv import load_dotenv

# ----------------------------
# LOAD ENV
# ----------------------------
load_dotenv()

AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
AWS_REGION = os.getenv("AWS_REGION")
BUCKET_NAME = os.getenv("S3_BUCKET_NAME")
LOCAL_FOLDER = os.getenv("LOCAL_DATA_FOLDER", "./data")

# ----------------------------
# DATE SUFFIX
# ----------------------------
date_suffix = datetime.now().strftime("%Y-%m-%d")

# ----------------------------
# FILE LIST
# ----------------------------
files = [
    "agents.csv",
    "clients.csv",
    "escalation_log.csv",
    "priority_levels.csv",
    "sla_definitions.csv",
    "ticket_audit_log.csv",
    "ticket_categories.csv",
    "tickets.csv"
]

# ----------------------------
# S3 CLIENT
# ----------------------------
s3 = boto3.client(
    "s3",
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    region_name=AWS_REGION
)

# ----------------------------
# CLEAN CSV (REMOVE BOM + SAVE UTF-8)
# ----------------------------
def clean_csv(input_path, output_path):
    df = pd.read_csv(input_path, encoding="utf-8-sig")  # removes BOM safely
    df.to_csv(output_path, index=False, encoding="utf-8")  # clean UTF-8
    return output_path

# ----------------------------
# UPLOAD FUNCTION
# ----------------------------
def upload_file(file_name):
    raw_path = os.path.join(LOCAL_FOLDER, file_name)

    if not os.path.exists(raw_path):
        print(f"File not found: {raw_path}")
        return

    base_name = file_name.replace(".csv", "")

    # temporary cleaned file
    clean_path = os.path.join(LOCAL_FOLDER, f"clean_{file_name}")

    # step 1: clean BOM + enforce UTF-8
    clean_csv(raw_path, clean_path)

    # step 2: S3 path
    s3_key = f"raw/{base_name}/{base_name}_{date_suffix}.csv"

    # step 3: upload
    try:
        s3.upload_file(clean_path, BUCKET_NAME, s3_key)
        print(f" Uploaded CLEAN file: {file_name} → s3://{BUCKET_NAME}/{s3_key}")
    except Exception as e:
        print(f"Failed: {file_name} | Error: {str(e)}")

    # step 4: remove temp file
    os.remove(clean_path)

# ----------------------------
# RUN
# ----------------------------
print(f"\n Cleaning + uploading to S3 bucket: {BUCKET_NAME}")
print(f" Date suffix: {date_suffix}\n")

for file in files:
    upload_file(file)

print("\n All files cleaned and uploaded successfully.")