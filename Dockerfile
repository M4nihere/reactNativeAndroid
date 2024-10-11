# Use the React Native Android Docker image
FROM reactnativecommunity/react-native-android

# Set the working directory
WORKDIR /app

# Copy your project files to the Docker image
COPY . .

# Install project dependencies
RUN npm install

# Create local.properties file for Gradle
RUN echo "sdk.dir=/usr/local/android-sdk" > android/local.properties

# Build the APK
RUN cd android && ./gradlew assembleRelease
