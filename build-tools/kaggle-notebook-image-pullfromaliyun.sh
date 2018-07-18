echo ""
echo "================================================================="
echo "Pulling kaggle-notebook-image from aliyun.com ..."
echo "This tools created by openthings, NO WARANTY. 2018.07.18."
echo "================================================================="

MY_REGISTRY=registry.cn-hangzhou.aliyuncs.com/openthings

echo ""
echo "1. kaggle-notebook-image"
docker pull ${MY_REGISTRY}/kubeflow-images-public-kaggle-notebook-image:latest
docker tag ${MY_REGISTRY}/kubeflow-images-public-kaggle-notebook-image:latest kubeflow-kaggle-notebook:latest 

echo ""
echo "pulled ${MY_REGISTRY}/kubeflow-images-public-kaggle-notebook-image:latest"
echo "tagged to kubeflow-kaggle-notebook:latest"
echo "Finished."
echo ""
