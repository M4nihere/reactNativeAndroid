# Use the latest Node.js LTS version
FROM node:lts

# Install OpenJDK 17 and Android SDK
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Android SDK and command-line tools
ENV ANDROID_HOME /usr/lib/android-sdk
RUN mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME} && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip commandlinetools-linux-11076708_latest.zip && \
    rm commandlinetools-linux-11076708_latest.zip

# Add tools to the path
ENV PATH "${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools"

# Install Android SDK components
RUN yes | sdkmanager --sdk_root=${ANDROID_HOME} --licenses && \
    sdkmanager --sdk_root=${ANDROID_HOME} "platforms;android-31" "build-tools;31.0.0"

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json yarn.lock ./
RUN npm install

# Copy the rest of your application code
COPY . .

# Expose the port (optional for development)
EXPOSE 8081

# Command to start the React Native server (optional)
CMD ["npm", "start"]
