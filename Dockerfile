FROM autoware/autoware:latest-melodic-cuda

USER autoware

RUN source ~/.bashrc
RUN rosdep update

# Configure terminal colors
RUN gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_background" --type bool false && \
    gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_colors" --type bool false && \
    gconftool-2 --set "/apps/gnome-terminal/profiles/Default/background_color" --type string "#000000"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV AUTOWARE_WORKSPACE=/home/$USERNAME/autoware.ai

RUN rm -r /home/$USERNAME/Autoware && mkdir $AUTOWARE_WORKSPACE

# Build Autoware
RUN bash -c 'mkdir -p /home/$USERNAME/Autoware/src; \
    cd /home/$USERNAME/Autoware; \
    wget https://gitlab.com/autowarefoundation/autoware.ai/autoware/raw/$VERSION/autoware.ai.repos; \
    vcs import src < autoware.ai.repos; \
    source /opt/ros/$ROS_DISTRO/setup.bash; \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release'

RUN sudo apt-get update

RUN echo "source $AUTOWARE_WORKSPACE/install/local_setup.bash" >> \
    /home/$USERNAME/.bashrc

COPY ./entrypoint.sh /tmp
ENTRYPOINT ["/tmp/entrypoint.sh"]
