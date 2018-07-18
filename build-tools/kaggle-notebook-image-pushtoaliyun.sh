
echo ""
echo "================================================================="
echo "Pushing kaggle-notebook-image to aliyun.com ..."
echo "This tools created by openthings, NO WARANTY. 2018.07.18."
echo "================================================================="

MY_REGISTRY=registry.cn-hangzhou.aliyuncs.com/openthings

echo ""
echo "1. kaggle-notebook-image"
docker tag kubeflow-kaggle-notebook:latest ${MY_REGISTRY}/kubeflow-images-public-kaggle-notebook-image:latest
docker push ${MY_REGISTRY}/kubeflow-images-public-kaggle-notebook-image:latest

echo ""
echo "pushed ${MY_REGISTRY}/kubeflow-images-public-kaggle-notebook-image:latest"
echo "Finished."
echo ""
