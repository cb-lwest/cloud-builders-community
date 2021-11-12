#
#!/bin/bash
regions=( 
    us-east4
)
# 84 zones
zones=(
    us-east4-a
    us-east4-b
    us-east4-c
)

for i in "${!regions[@]}"; do
    REGION=${regions[i]}
    ZONE=${zones[i]}
    BUCKET_NAME=$PROJECT_ID-$ZONE-tfbucket-1
    gsutil mb -l $REGION gs://$BUCKET_NAME
    printf "Running in region %s, zone %s\n" "${REGION}" "${ZONE}"
    (gcloud builds submit  \
        --worker-pool=projects/${PROJECT_ID}/locations/${WORKER_POOL_REGION}/workerPools/${WORKER_POOL_ID} . \
        --timeout=1200s \
        --config=cloudbuild.yaml \
        --region=$WORKER_POOL_REGION \
        --substitutions=_BUCKET=$BUCKET_NAME,_REGION=$REGION,_ZONE=$ZONE &)
done
wait