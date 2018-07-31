echo ""
echo "Building kubeflow-kaggle-notebook..."
echo "cd ../components/contrib/kaggle-notebook-image"

cd ../components/contrib/kaggle-notebook-image
docker build --pull -t kubeflow-kaggle-notebook:latest .

echo ""
