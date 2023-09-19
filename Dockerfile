FROM ubuntu
FROM python

### Installation of curl ###
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

### System libraries ###
ARG LIB_DEV_LIST="libnss3-dev libpcre3-dev zlib1g-dev liblzma-dev libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev libasound2 libswt-gtk-4-java libswt-gtk-4-jni libdrm2 libxcomposite1 libxdamage1 libxrandr2 libxkbcommon0 liblog4j2-java "

RUN apt-get update -y && \
    apt-get install -y ${LIB_DEV_LIST} && \
    apt-get install -y sudo && \
    apt-get install -y unzip && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

### Python libraries ###
### RUN pip install os
### RUN pip install subprocess
RUN pip install psutil
RUN pip install py4j
RUN pip install pyarrow
RUN pip install numpy
RUN pip install pandas
RUN pip install matplotlib
RUN pip install pydoe
RUN pip install diversipy

### Installation of KNIME with all Extensions ###
RUN curl -k -O https://download.knime.org/analytics-platform/linux/knime-full_5.1.0.linux.gtk.x86_64.tar.gz && \
    tar xvf knime-*.tar.gz && \
    rm -f knime-*.tar.gz && \
    ln -s knime-* knime
ENV PATH=/knime:$PATH

### Remove knime-workspace.zip to avoid blank screen ###
RUN unzip /knime-full_5.1.0/knime-workspace.zip -d /knime-full_5.1.0/knime-workspace && \
    rm /knime-full_5.1.0/knime-workspace.zip

### log4j .jar-Files ###
ADD lib/log4j-core-3.0.0-alpha1.jar /knime-full_5.1.0/plugins
ADD lib/log4j-api-3.0.0-alpha1.jar /knime-full_5.1.0/plugins

### Workflow to execute ###
### ADD workflow/KNIME-Workflow /root/Workflow-Folder

### Open KNIME ###
CMD "$-/knime-full_5.1.0/knime"

### Execute workflow without GUI ###
### ENTRYPOINT /knime-full_5.1.0/knime -nosave -consoleLog -noexit -nosplash -reset -application org.knime.product.KNIME_BATCH_APPLICATION -workflowDir=/workflow