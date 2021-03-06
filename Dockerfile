FROM paopaorobot/ubuntu-xfce-vnc

LABEL Name=general Version=0.0.1
MAINTAINER YiQun GONG<gongyiqun51237@163.com>

ENV JOBS_NUM="2"

RUN apt-get -y update && apt-get install -y \
    libboost-all-dev cmake-gui\
	cmake git zsh autojump\
	libgoogle-glog-dev libsuitesparse-dev\
	libeigen3-dev build-essential

RUN apt-get -y update && apt-get install -y libopencv-dev \
    libgtest-dev libzip-dev && rm -rf /var/lib/apt/lists/*

RUN apt-get -y update && apt-get install -y \
    libgl1-mesa-dev \
	libglew-dev \
	libxkbcommon-x11-dev  && \
    rm -rf /var/lib/apt/lists/*

RUN cd /root && \
	git clone https://github.com/stevenlovegrove/Pangolin.git && \
	cd Pangolin && mkdir build && cd build && \
	cmake .. && make -j${JOBS_NUM} install && \
	rm -rf /root/Pangolin

RUN cd /root && \
    git clone https://github.com/JakobEngel/dso.git && \
    cd dso && mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM}

RUN cd /root && \
    git clone https://github.com/tum-vision/LDSO.git && \
    cd LDSO/thirdparty/DBoW3 && mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM} && \
    cd ../../g2o && mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM} && \
    cd ../../.. && mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM}

RUN git clone https://github.com/alalagong/oh-my-zsh-gong.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc_gong.zsh-template ~/.zshrc \
    && chsh -s /bin/zsh

RUN rm /root/startup.sh 

ADD startup.sh ./

EXPOSE 5900
EXPOSE 22

ENTRYPOINT ["./startup.sh"]