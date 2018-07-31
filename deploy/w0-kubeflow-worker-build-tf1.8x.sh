
echo ""
echo "Build Tensorflow 1.8.0 with CPU for kubeflow."
echo ""

echo "cd ../components"
cd ../components

python3 build_image.py --registry=openthings --tag=1.8.0x --tf_version=1.8.0x --platform=cpu tf_notebook

echo "==============Finished.==============================="
echo ""
