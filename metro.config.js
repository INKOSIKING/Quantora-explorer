const { getDefaultConfig, mergeConfig } = require('@react-native/metro-config');
const exclusionList = require('metro-config/src/defaults/exclusionList');

const config = {
  resolver: {
    blacklistRE: exclusionList([
      /node_modules\/react-native\/ReactCommon\/react\/renderer\/debug\/tests\/.*$/,
      /node_modules\/react-native\/ReactCommon\/react\/renderer\/components\/rncore\/.*$/,
      /node_modules\/expo-web-browser\/android\/src\/main\/java\/.*$/,
      /node_modules\/expo-system-ui\/android\/src\/main\/res\/.*$/,
    ]),
    sourceExts: ['js', 'json', 'ts', 'tsx', 'jsx'],
  },
  watchFolders: [],
};

module.exports = mergeConfig(getDefaultConfig(__dirname), config);
