# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

ARG BASE_IMAGE=ubuntu:18.04@sha256:de774a3145f7ca4f0bd144c7d4ffb2931e06634f11529653b23eba85aef8e378

FROM $BASE_IMAGE

<<<<<<< HEAD
# ====================================================================
# Add proxy, using --build-arg "HTTP_PROXY=http://192.168.199.99:9999"

ENV HTTP_PROXY ${HTTP_PROXY}
ENV HTTPS_PROXY ${HTTP_PROXY}
ENV http_proxy ${HTTP_PROXY}
ENV https_proxy ${HTTP_PROXY}
# ====================================================================

ARG INSTALL_TFMA=yes
=======
>>>>>>> upstream/master
ARG TF_PACKAGE=https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.7.0-cp36-cp36m-linux_x86_64.whl
ARG TF_PACKAGE_PY_27=https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.7.0-cp27-none-linux_x86_64.whl
ARG TF_SERVING_VERSION=0.0.0
ARG TFMA_VERSION
ARG TFDV_VERSION

USER root

ENV DEBIAN_FRONTEND noninteractive

ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/$NB_USER
# We prefer to have a global conda install
# to minimize the amount of content in $HOME
ENV CONDA_DIR=/opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

# Export args as environment variables.
# This is solely to make them available to install.sh
ENV TF_PACKAGE $TF_PACKAGE
ENV TF_PACKAGE_27 $TF_PACKAGE_PY_27
ENV TF_SERVING_VERSION $TF_PACKAGE_PY_27
ENV TFMA_VERSION $TFMA_VERSION
ENV TFDV_VERSION $TFDV_VERSION

# Use bash instead of sh
SHELL ["/bin/bash", "-c"]


# ====================================================================
RUN echo "http_proxy: "$http_proxy
RUN apt-get update && apt-get install -yq --no-install-recommends \
  apt-transport-https \
  build-essential \
  bzip2 \
  ca-certificates \
  curl \
  g++ \
  git \
  gnupg \
  graphviz \
  locales \
  lsb-release \
  openssh-client \
  sudo \
  unzip \
  vim \
  wget \
  zip \
  && apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Create jovyan user with UID=1000 and in the 'users' group
# but allow for non-initial launches of the notebook to have
# $HOME provided by the contents of a PV
RUN useradd -M -s /bin/bash -N -u $NB_UID $NB_USER && \
    chown -R ${NB_USER}:users /usr/local/bin && \
    mkdir -p $HOME
# ====================================================================

# ====================================================================
# Install cloud packages.
# ====================================================================
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - &&  \
    apt-get update && \
    apt-get install -y google-cloud-sdk kubectl

# Install Tini - used as entrypoint for container
RUN cd /tmp && \
    wget https://github.com/krallin/tini/releases/download/v0.18.0/tini && \
    #echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# ====================================================================
# Install conda as jovyan user and check the md5 sum provided on the download site
# ====================================================================
ENV MINICONDA_VERSION 4.4.10
RUN cd /tmp && \
    mkdir -p $CONDA_DIR && \
    wget https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "bec6203dbb2f53011e974e9bf4d46e93 *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p ${CONDA_DIR} && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh

# ====================================================================
# Add conda install mirror and  pip install mirror.
# ====================================================================
RUN echo $http_proxy && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ && \
    conda config --set show_channel_urls yes

RUN echo "[global] \
index-url = http://pypi.tuna.tsinghua/simple \
trusted-host = \
    pypi.tuna.tsinghua \
#timeout = 120 \
" > /etc/pip.conf
# ====================================================================

# ====================================================================
# Conda config and jupyter config.
# ====================================================================
#RUN conda config --system --prepend channels conda-forge && \
RUN conda config --system --append channels conda-forge && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    conda update --all && \
    conda update conda && \
    conda clean -tipsy

# NOTE: Beyond this point be careful of breaking out
# or otherwise adding new layers with RUN, chown, etc.
# The image size can grow significantly.

# Install base python3 packages
RUN https_proxy="" pip install --upgrade pip
RUN pip --no-cache-dir install \
    # Tensorflow
    ${TF_PACKAGE} \
    # Jupyter Stuff
    lxml bs4 \
    ipyleaflet \
    jupyter \
    jupyter-console==6.0.0 \
    jupyterhub \
    jupyterlab \
    mlflow \
    airflow \
    # Cleanup
    && conda clean -tipsy
# ====================================================================

# ====================================================================
# Install iclientpy based python3.
# RUN conda install -y -c http://iclientpy.supermap.io/conda/channel iclientpy
# ====================================================================

# Install iclientpy based python3.
RUN conda install --quiet --yes \
    # nodejs required for jupyterlab-manager
    nodejs=8.11.3

#RUN conda install --quiet --yes -c conda-forge ipyleaflet 
#RUN pip install ipyleaflet

RUN jupyter labextension install jupyter-leaflet && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager 
    
#RUN conda install --quiet --yes -c http://iclientpy.supermap.io/conda/channel iclientpy

<<<<<<< HEAD
# Install python2 and ipython2 kernel for jupyter notebook
# Install tf packages which only support py2
#RUN conda create -n py2 python=2 && \
#    source activate py2 && \
#    pip install --upgrade pip && \
#    pip --no-cache-dir install \
#    ipykernel \
#    # Tensorflow
#    ${TF_PACKAGE_PY_27} \
#    # Tensorflow packages which only supports python 2
#    tensorflow-transform \
#    tensorflow-serving-api \
#    # ipykernel for python 2 jupyter notebook kernel
#    && \
#    python -m ipykernel install && \
#    # tensorflow-model-analysis is only supported for TF 1.6 and above
#    if [[ $INSTALL_TFMA == "yes" ]]; then \
#      pip install --no-cache-dir tensorflow-model-analysis && \
#      # We use --system because if we don't the config is written to the home directory
#      # and the changes are lost when we mount a PV over them.
#      jupyter nbextension install --py --system --symlink tensorflow_model_analysis && \
#      jupyter nbextension enable --py --system tensorflow_model_analysis ; \
#    fi \
#    && \
#    # Install jupyterlab-manager
#    conda install --quiet --yes \
#    # nodejs required for jupyterlab-manager
#    nodejs && \
#    jupyter labextension install jupyter-leaflet && \
#    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
#    # Do chown in this layer for significant size savings
#    chown -R ${NB_USER}:users $HOME && \
#    chown -R ${NB_USER}:users $CONDA_DIR

# Install common packages from requirements.txt for both python2 and python3
=======
>>>>>>> upstream/master
# NB: the COPY chown can't expand a bash variable for NB_USER
COPY --chown=jovyan:users requirements.txt /tmp

# Install python2 and ipython2 kernel for jupyter notebook
# Install tf packages which only support py2
COPY --chown=jovyan:users install.sh /tmp/
RUN chmod a+rx /tmp/install.sh && \
    /tmp/install.sh

# Add basic config
COPY --chown=jovyan:users  jupyter_notebook_config.py /tmp
<<<<<<< HEAD

RUN pip --no-cache-dir install -r /tmp/requirements.txt

#RUN pip --no-cache-dir install -r /tmp/requirements.txt && \
#    source activate py2 && \
#    pip --no-cache-dir install -r /tmp/requirements.txt

# ====================================================================
# Clean the proxy config.
# ====================================================================
ENV HTTP_PROXY ""
ENV HTTPS_PROXY ""
ENV http_proxy ""
ENV https_proxy ""
# ====================================================================
=======
>>>>>>> upstream/master

# Wipe $HOME for PVC detection later
WORKDIR $HOME
RUN rm -fr $(ls -A $HOME)

# Copy over init scripts
COPY --chown=jovyan:users start-singleuser.sh start-notebook.sh start.sh pvc-check.sh /usr/local/bin/
RUN chmod a+rx /usr/local/bin/*

# Configure container startup
EXPOSE 8888
ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"]
