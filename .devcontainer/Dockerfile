FROM python:3.8.8

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update
RUN apt-get install -y mongo-tools

# Install pip packages
RUN pip install pip-tools

# Create a non-root user
ARG USERNAME=python-dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID --shell /bin/bash -m $USERNAME

# Prompt gpg window inside container for signing commits & setup folder permissions for non-root user
RUN echo 'export GPG_TTY="$(tty)"' >> /home/$USERNAME/.bashrc \
    && mkdir /home/$USERNAME/.gnupg \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME/.gnupg

# Persist bash history between runs
RUN HIST_SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R $USERNAME /commandhistory \
    && echo $HIST_SNIPPET >> "/home/$USERNAME/.bashrc"

# Add local bin to PATH
RUN LOCAL_BIN_SNIPPET="PATH=/home/$USERNAME/.local/bin:$PATH" \
    && echo $LOCAL_BIN_SNIPPET >> "/home/$USERNAME/.bashrc"


# Enter container as non-root user
USER $USERNAME